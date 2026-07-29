import type { Plugin } from "@opencode-ai/plugin";

/**
 * Guardrails plugin for OpenCode.
 *
 * Enforces seven operational disciplines:
 *   1. Subagent nesting prevention — blocks subagents from spawning subagents
 *   2. Orchestration skill blocking — prevents subagents from loading dispatch-heavy skills
 *   3. LSP-first enforcement — blocks grep/glob for symbol-like patterns
 *   4. Plan-mode redirect blocking — blocks output redirects that bypass edit:deny
 *   5. Hardware-key retry guard — stops signing/network workarounds after a missed touch
 *   6. Skill activation nudges — reminds the model to invoke relevant skills
 *   7. Subagent dispatch reminders — per-turn reminder keeping plan/build agents
 *      on the explore → implement → review dispatch loop
 *
 * Works alongside the superpowers bootstrap and rtk plugins.
 */

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/** Maps sessionID → agent name. Populated from resolved chat messages and params. */
const sessionAgentMap = new Map<string, string>();

/** Maps sessionID → set of skill names already nudged. One nudge per skill per session. */
const nudgedSkills = new Map<string, Set<string>>();

/** Sessions currently producing or processing compaction messages. */
const compactingSessions = new Set<string>();

/** Reminder parts injected by this plugin into a live message array. */
const injectedPrimaryReminderParts = new WeakSet<object>();

/** Agents that must NOT spawn subagents via the task tool. */
const SUBAGENTS = new Set(["general", "explore", "reviewer"]);

/**
 * Orchestration/lifecycle skills that require subagent dispatch.
 * Blocked for subagents to avoid wasted tokens — the model would load the skill,
 * plan the dispatch, call task, hit the nesting block, and have to recover.
 */
const SUBAGENT_BLOCKED_SKILLS = new Set([
  "subagent-driven-development",
  "dispatching-parallel-agents",
  "requesting-code-review",
  "executing-plans",
  "finishing-a-development-branch",
]);

// ---------------------------------------------------------------------------
// LSP enforcement config
// ---------------------------------------------------------------------------

/**
 * Regex matching grep patterns that are clearly symbol-definition searches.
 * Anchored to start-of-pattern to avoid false positives on prose searches.
 *
 * Matches:  "class Foo", "function baz", "interface Qux"
 * Skips:    "error in class handling", "undefined function call"
 *
 * "def" is deliberately NOT in the list: it is Python's definition keyword,
 * and grep is the documented fallback for Python symbol search because
 * basedpyright's workspaceSymbol and cross-file findReferences are broken
 * (see AGENTS.md, Language-Specific Notes).
 */
const SYMBOL_DEFINITION_RE =
  /^\s*\b(class|function|func|interface|struct|type|enum|impl|trait|module|package)\s+\w+/;

/**
 * File extensions for which LSP symbol search is reliable.
 * If the grep `include` filter targets only other files, we let it through.
 *
 * Python (.py/.pyi) is deliberately EXCLUDED: basedpyright's workspaceSymbol
 * and cross-file findReferences are broken (see AGENTS.md), so grep is the
 * documented fallback for Python symbol searches.
 */
const LSP_EXTENSIONS = new Set([
  ".ts",
  ".tsx", // tsserver
  ".js",
  ".jsx", // tsserver
  ".go", // gopls
]);

function includeTargetsLspFiles(include: string | undefined): boolean {
  if (!include) return true; // no filter → assume LSP-eligible files are in scope
  // include looks like "*.py" or "*.{ts,tsx}" — check if any LSP extension matches
  for (const ext of LSP_EXTENSIONS) {
    if (include.includes(ext.slice(1))) return true; // compare without leading dot
  }
  return false;
}

// ---------------------------------------------------------------------------
// Plan-mode redirect guard config
// ---------------------------------------------------------------------------

/**
 * Matches output redirections that write to a real file.
 *
 * opencode's bash permission matcher strips redirections from the matched
 * command text (verified empirically: `git remote < /dev/null` auto-passes
 * an exact-match `git remote` rule), so `ls > file` silently matches an
 * `ls *` allow rule and writes a file even under edit:deny. Plugins see the
 * RAW command string, so we block output redirects here — for the plan agent
 * only; build mode keeps legitimate redirects (e.g. `cmd > log 2>&1`).
 *
 * Catches: `>`, `>>`, `2>`, `&>`, `12>` targeting real paths.
 * Ignores: fd-dups (`2>&1`, `>&2`) and `/dev/null|stderr|stdout` sinks.
 * Known false positive: a literal ">" inside quoted arguments (e.g. git
 * pretty-format arrows) throws a recoverable error — acceptable in plan mode.
 */
const OUTPUT_REDIRECT_RE =
  /(?:^|[^<])(?:&|\d+)?>{1,2}(?!&)\s*(?!\/dev\/(null|stderr|stdout)\b)\S/;

// ---------------------------------------------------------------------------
// Hardware-key retry guard config
// ---------------------------------------------------------------------------

const HARDWARE_KEY_RETRY_MARKER = "<hardware-key-retry-guard>";
const GPG_SIGNING_FAILURE_RE = /gpg failed to sign the data|gpg: signing failed/i;
const COMMIT_WRITE_FAILURE_RE = /fatal: failed to write commit object/i;
// Confirmed live: the bash tool reports a killed command as
// "shell tool terminated command after exceeding timeout <N> ms". Matching the
// diagnostic sentence (not a bare "exceeding timeout") avoids colliding with a
// Git commit subject that happens to contain those words.
const COMMAND_TIMEOUT_RE = /terminated command after exceeding timeout/i;
const NETWORK_KEY_FAILURE_RE =
  /Confirm user presence for key|Permission denied \(publickey\)/;

const GIT_NETWORK_SUBCOMMANDS = new Set([
  "push",
  "fetch",
  "pull",
  "clone",
  "ls-remote",
]);
const GIT_SIGNING_SUBCOMMANDS = new Set([
  "commit",
  "merge",
  "rebase",
  "cherry-pick",
  "revert",
  "am",
  "pull",
  "tag",
]);
const GIT_COMMIT_SIGNING_SUBCOMMANDS = new Set([
  "commit",
  "merge",
  "rebase",
  "cherry-pick",
  "revert",
  "am",
  "pull",
]);
const GIT_GLOBAL_OPTIONS_WITH_OPERAND = new Set([
  "-C",
  "-c",
  "--config-env",
  "--git-dir",
  "--work-tree",
  "--namespace",
  "--exec-path",
]);
const GIT_CONFIG_READ_OPTIONS = new Set([
  "--get",
  "--get-all",
  "--get-regexp",
  "--get-urlmatch",
  "--list",
]);
const GIT_CONFIG_OPTIONS_WITH_OPERAND = new Set([
  "--file",
  "--blob",
  "--type",
  "--default",
]);

interface GitConfigValue {
  key: string;
  value: string;
}

interface GitConfigEnvironment {
  key: string;
  environmentName: string;
}

interface GitInvocation {
  args: string[];
  configValues: GitConfigValue[];
  configEnvironment: GitConfigEnvironment[];
  environment: Map<string, string>;
  subcommand?: string;
  subcommandIndex: number;
}

interface GitCommandClassification {
  hasGit: boolean;
  subcommands: string[];
  hasNetwork: boolean;
  hasSigningCapable: boolean;
}

/**
 * Splits only the shell forms rtk emits: quotes, backslash escapes, and the
 * chain operators &&, ||, ;, and |. Command substitution and subshells are
 * deliberately unsupported; treating those commands as unclassifiable avoids
 * making an unsafe guess about which git invocation will actually run.
 */
function tokenizeShell(command: string): string[][] | undefined {
  const segments: string[][] = [];
  let tokens: string[] = [];
  let current = "";
  let tokenStarted = false;
  let quote: "'" | '"' | undefined;

  const finishToken = () => {
    if (tokenStarted) {
      tokens.push(current);
      current = "";
      tokenStarted = false;
    }
  };

  const finishSegment = () => {
    finishToken();
    if (tokens.length === 0) return false;
    segments.push(tokens);
    tokens = [];
    return true;
  };

  for (let index = 0; index < command.length; index++) {
    const character = command[index];

    if (quote === "'") {
      // POSIX single quotes preserve every character except their closing quote.
      if (character === quote) {
        quote = undefined;
      } else {
        current += character;
      }
      continue;
    }

    if (quote) {
      if (character === quote) {
        quote = undefined;
      } else if (character === "\\") {
        if (index + 1 >= command.length) return undefined;
        current += command[++index];
      } else if (character === "$" && command[index + 1] === "(") {
        return undefined;
      } else if (character === "`") {
        return undefined;
      } else {
        current += character;
      }
      continue;
    }

    if (character === "'" || character === '"') {
      quote = character;
      tokenStarted = true;
      continue;
    }
    if (character === "\\") {
      if (index + 1 >= command.length) return undefined;
      current += command[++index];
      tokenStarted = true;
      continue;
    }
    if (/\s/.test(character)) {
      finishToken();
      continue;
    }
    if (
      character === "`" ||
      character === "(" ||
      character === ")" ||
      (character === "$" && command[index + 1] === "(")
    ) {
      return undefined;
    }
    if (character === ";" || character === "|" || character === "&") {
      if (character === "&" && command[index + 1] !== "&") {
        current += character;
        tokenStarted = true;
        continue;
      }
      if (!finishSegment()) return undefined;
      if (
        (character === "&" && command[index + 1] === "&") ||
        (character === "|" && command[index + 1] === "|")
      ) {
        index++;
      }
      continue;
    }

    current += character;
    tokenStarted = true;
  }

  if (quote) return undefined;
  finishToken();
  if (tokens.length > 0) {
    segments.push(tokens);
  } else if (segments.length > 0) {
    return undefined;
  }
  return segments;
}

function parseConfigValue(value: string | undefined): GitConfigValue | undefined {
  if (!value) return undefined;
  const separator = value.indexOf("=");
  if (separator < 1) return undefined;
  return {
    key: value.slice(0, separator).toLowerCase(),
    value: value.slice(separator + 1),
  };
}

function parseConfigEnvironment(
  value: string | undefined,
): GitConfigEnvironment | undefined {
  if (!value) return undefined;
  const separator = value.indexOf("=");
  if (separator < 1 || separator === value.length - 1) return undefined;
  return {
    key: value.slice(0, separator).toLowerCase(),
    environmentName: value.slice(separator + 1),
  };
}

function parseGitInvocation(tokens: string[]): GitInvocation | undefined {
  const environment = new Map<string, string>();
  let index = 0;

  while (index < tokens.length) {
    const assignment = /^([A-Za-z_][A-Za-z0-9_]*)=(.*)$/.exec(tokens[index]);
    if (!assignment) break;
    environment.set(assignment[1], assignment[2]);
    index++;
  }

  if (tokens[index] === "rtk") index++;
  if (tokens[index] !== "git") return undefined;

  const args = tokens.slice(index + 1);
  const configValues: GitConfigValue[] = [];
  const configEnvironment: GitConfigEnvironment[] = [];

  for (let argIndex = 0; argIndex < args.length; argIndex++) {
    const token = args[argIndex];

    if (token === "-c") {
      const configValue = parseConfigValue(args[argIndex + 1]);
      if (configValue) configValues.push(configValue);
      argIndex++;
      continue;
    }
    if (token.startsWith("-c") && token.length > 2) {
      const configValue = parseConfigValue(token.slice(2));
      if (configValue) configValues.push(configValue);
      continue;
    }
    if (token === "--config-env") {
      const configValue = parseConfigEnvironment(args[argIndex + 1]);
      if (configValue) configEnvironment.push(configValue);
      argIndex++;
      continue;
    }
    if (token.startsWith("--config-env=")) {
      const configValue = parseConfigEnvironment(token.slice("--config-env=".length));
      if (configValue) configEnvironment.push(configValue);
      continue;
    }
    if (GIT_GLOBAL_OPTIONS_WITH_OPERAND.has(token)) {
      argIndex++;
      continue;
    }
    if (
      token.startsWith("-C") ||
      token.startsWith("--git-dir=") ||
      token.startsWith("--work-tree=") ||
      token.startsWith("--namespace=") ||
      token.startsWith("--exec-path=")
    ) {
      continue;
    }
    if (token.startsWith("-")) continue;

    return {
      args,
      configValues,
      configEnvironment,
      environment,
      subcommand: token.toLowerCase(),
      subcommandIndex: argIndex,
    };
  }

  return {
    args,
    configValues,
    configEnvironment,
    environment,
    subcommandIndex: -1,
  };
}

function parseGitInvocations(command: string): GitInvocation[] {
  const segments = tokenizeShell(command);
  if (!segments) return [];

  const invocations: GitInvocation[] = [];
  for (const segment of segments) {
    const invocation = parseGitInvocation(segment);
    if (invocation) invocations.push(invocation);
  }
  return invocations;
}

function firstSubcommandArgument(invocation: GitInvocation): string | undefined {
  for (
    let index = invocation.subcommandIndex + 1;
    index < invocation.args.length;
    index++
  ) {
    const token = invocation.args[index];
    if (!token.startsWith("-")) return token.toLowerCase();
  }
  return undefined;
}

function isSigningCapableGitInvocation(invocation: GitInvocation): boolean {
  if (
    invocation.subcommand === undefined ||
    !GIT_SIGNING_SUBCOMMANDS.has(invocation.subcommand)
  ) {
    return false;
  }
  if (invocation.subcommand !== "tag") return true;

  return !invocation.args.slice(invocation.subcommandIndex + 1).some(
    (arg) =>
      arg === "-l" ||
      arg === "--list" ||
      arg.startsWith("--list=") ||
      arg === "-n" ||
      (arg.startsWith("-n") && arg.length > 2) ||
      arg === "-v" ||
      arg === "--verify",
  );
}

function classifyGitCommand(command: string): GitCommandClassification {
  const invocations = parseGitInvocations(command);
  const subcommands = invocations.flatMap((invocation) =>
    invocation.subcommand ? [invocation.subcommand] : [],
  );

  return {
    hasGit: invocations.length > 0,
    subcommands,
    hasNetwork: invocations.some(
      (invocation) =>
        (invocation.subcommand !== undefined &&
          GIT_NETWORK_SUBCOMMANDS.has(invocation.subcommand)) ||
        (invocation.subcommand === "remote" &&
          ["update", "prune"].includes(firstSubcommandArgument(invocation) ?? "")),
    ),
    hasSigningCapable: invocations.some(isSigningCapableGitInvocation),
  };
}

function buildHardwareKeyRetryDirective(): string {
  return `<system-reminder>
${HARDWARE_KEY_RETRY_MARKER}
This git operation most likely FAILED because your hardware security key (smartcard) was not touched/confirmed in time — NOT because of a code or configuration problem.

Do the following, in order:
1. STOP. Do not retry the command yet and do not run it in a loop.
2. Do NOT work around this: do not disable or skip signing (no --no-gpg-sign, no --no-sign, no \`-c commit.gpgsign=false\`), do not change signing method, do not abandon the operation.
3. Ask the user to insert/touch their security key and confirm they are ready.
4. Only after the user confirms, retry the EXACT same command once.
If the user says this was a genuine network or configuration error rather than a missing touch, follow their direction instead.
</hardware-key-retry-guard>
</system-reminder>`;
}

function removeEchoedCommandText(haystack: string, command: string): string {
  return haystack.split(command).join("");
}

function metadataContainsTimeout(metadata: unknown, command: string): boolean {
  try {
    const serialized = JSON.stringify(metadata);
    return (
      typeof serialized === "string" &&
      COMMAND_TIMEOUT_RE.test(removeEchoedCommandText(serialized, command))
    );
  } catch {
    // Metadata can contain circular values; detection must never break the hook.
    return false;
  }
}

function detectHardwareKeyFailure(
  command: string,
  output: string,
  metadata: unknown,
): boolean {
  if (output.includes(HARDWARE_KEY_RETRY_MARKER)) return false;

  const classification = classifyGitCommand(command);
  if (!classification.hasGit) return false;

  const outputHasTimeout = COMMAND_TIMEOUT_RE.test(
    removeEchoedCommandText(output, command),
  );
  const hasTimeout = outputHasTimeout || metadataContainsTimeout(metadata, command);
  const hasSigningFailure =
    GPG_SIGNING_FAILURE_RE.test(output) || COMMIT_WRITE_FAILURE_RE.test(output);
  const hasNetworkKeyFailure = NETWORK_KEY_FAILURE_RE.test(output);

  return (
    (classification.hasSigningCapable && (hasSigningFailure || hasTimeout)) ||
    (classification.hasNetwork && (hasTimeout || hasNetworkKeyFailure))
  );
}

function isFalseyGitConfigValue(value: string | undefined): boolean {
  return value !== undefined && ["false", "off", "no", "0"].includes(value.toLowerCase());
}

function hasFalseySigningConfig(
  invocation: GitInvocation,
  key: "commit.gpgsign" | "tag.gpgsign",
): boolean {
  return (
    invocation.configValues.some(
      (config) => config.key === key && isFalseyGitConfigValue(config.value),
    ) ||
    invocation.configEnvironment.some(
      (config) =>
        config.key === key &&
        isFalseyGitConfigValue(invocation.environment.get(config.environmentName)),
    )
  );
}

function configWriteDisablesSigning(invocation: GitInvocation): boolean {
  const configArgs = invocation.args.slice(invocation.subcommandIndex + 1);
  if (configArgs.some((arg) => GIT_CONFIG_READ_OPTIONS.has(arg))) return false;

  let isUnset = false;
  const positional: string[] = [];
  for (let index = 0; index < configArgs.length; index++) {
    const token = configArgs[index];
    if (token === "--unset" || token === "--unset-all") {
      isUnset = true;
      continue;
    }
    if (GIT_CONFIG_OPTIONS_WITH_OPERAND.has(token)) {
      index++;
      continue;
    }
    if (token.startsWith("--file=") || token.startsWith("--blob=") || token.startsWith("--type=")) {
      continue;
    }
    if (token.startsWith("-")) continue;
    positional.push(token);
  }

  const action = positional[0]?.toLowerCase();
  if (action === "get" || action === "list") return false;

  const usesModernSet = action === "set";
  const usesModernUnset = action === "unset" || action === "unset-all";
  const key = positional[usesModernSet || usesModernUnset ? 1 : 0]?.toLowerCase();
  if (key !== "commit.gpgsign" && key !== "tag.gpgsign") return false;
  if (isUnset || usesModernUnset) return true;
  return isFalseyGitConfigValue(positional[usesModernSet ? 2 : 1]);
}

function detectSigningDisable(command: string): boolean {
  for (const invocation of parseGitInvocations(command)) {
    const subcommand = invocation.subcommand;
    if (!subcommand) continue;

    if (
      GIT_COMMIT_SIGNING_SUBCOMMANDS.has(subcommand) &&
      (invocation.args.includes("--no-gpg-sign") ||
        hasFalseySigningConfig(invocation, "commit.gpgsign"))
    ) {
      return true;
    }
    if (
      subcommand === "tag" &&
      isSigningCapableGitInvocation(invocation) &&
      (invocation.args.includes("--no-sign") ||
        hasFalseySigningConfig(invocation, "tag.gpgsign"))
    ) {
      return true;
    }
    if (subcommand === "config" && configWriteDisablesSigning(invocation)) {
      return true;
    }
  }
  return false;
}

// ---------------------------------------------------------------------------
// Skill nudge config
// ---------------------------------------------------------------------------

interface SkillTrigger {
  skill: string;
  patterns: RegExp[];
  nudge: string;
}

const SKILL_TRIGGERS: SkillTrigger[] = [
  {
    skill: "surgical-commits",
    patterns: [
      /\bcommit\b/i,
      /\bready to (push|merge|ship)\b/i,
      /\bdone.*implement/i,
    ],
    nudge:
      "Before committing, invoke the `surgical-commits` skill to ensure atomic, well-formatted commits.",
  },
  {
    skill: "subagent-driven-development",
    patterns: [
      /\bexecute.*plan\b/i,
      /\bimplement.*plan\b/i,
      /\btask.*list\b.*implement/i,
    ],
    nudge:
      "You have a plan with tasks to implement. Consider invoking `subagent-driven-development` skill for structured parallel execution.",
  },
  {
    skill: "systematic-debugging",
    patterns: [
      /\bbug\b/i,
      /\bfailing test/i,
      /\btest.*fail/i,
      /\bunexpected (behavior|behaviour|error|result)/i,
      /\bbroken\b/i,
    ],
    nudge:
      "This looks like a debugging task. Invoke `systematic-debugging` skill before proposing fixes.",
  },
  {
    skill: "requesting-code-review",
    patterns: [
      /\breview (my|this|the) (work|code|change|implementation)/i,
      /\bcheck my work\b/i,
    ],
    nudge:
      "Consider invoking `requesting-code-review` skill to verify work meets requirements before submitting.",
  },
];

// ---------------------------------------------------------------------------
// Subagent dispatch reminder config
// ---------------------------------------------------------------------------

/**
 * Per-prompt-build reminders that keep primary agents on the subagent
 * dispatch loop (explore → general implements → reviewer reviews).
 *
 * Anchor choice: appended to the LATEST user message — the same mechanism
 * opencode itself uses for the (empirically reliable) plan-mode read-only
 * reminder. The dispatch decision happens early in a turn, before tool
 * results stack, which is exactly when this anchor is freshest. If context
 * drift during long tool loops ever proves to be a real problem, the
 * escalation path is `experimental.chat.system.transform` (its input lacks
 * agent info too, so the same sessionAgentMap lookup applies).
 *
 * The resolved latest user message supplies the primary-agent fallback when
 * a first turn transforms before the session map has been populated.
 *
 * Thresholds are taxonomy-based (task kind), NOT line counts — line-count
 * thresholds incentivize code-golfing to dodge dispatch.
 */
const PRIMARY_AGENT_TURN_REMINDER_MARKER = "<primary-agent-turn-reminder>";

const PRIMARY_AGENT_TURN_REMINDER =
  "Primary-agent turn start: Before any response or action on this turn, invoke `radio-4-english` once. If it has already been invoked for this turn, do not invoke it again. Invoke every applicable Superpowers skill alongside it. `radio-4-english` governs prose style only; it supplements and never replaces workflow/process skills.";

const DISPATCH_REMINDERS: Record<string, string> = {
  build: `<system-reminder>
${PRIMARY_AGENT_TURN_REMINDER_MARKER}
${PRIMARY_AGENT_TURN_REMINDER}
Dispatch policy (primary agent): default loop is explore → \`general\` implements → \`reviewer\` reviews → repeat until greenlight.
- Dispatch \`explore\`: understanding unfamiliar code, multi-file analysis, locating implementations.
- Dispatch \`general\`: feature additions, logic changes, refactors, multi-file changes, anything requiring tests.
- Dispatch \`reviewer\`: after ANY completed implementation or refactor, BEFORE claiming done.
Direct work is allowed ONLY for: typo/string fixes in known locations, config tweaks, running verification commands, or when the user explicitly tells you to do it yourself.
</system-reminder>`,
  plan: `<system-reminder>
${PRIMARY_AGENT_TURN_REMINDER_MARKER}
${PRIMARY_AGENT_TURN_REMINDER}
Dispatch policy (plan mode): research via \`explore\` subagent dispatches — do not bulk-read the codebase yourself. Reserve direct reads for 1-3 specific files you already know. Plans should assign implementation to \`general\` and reviews to \`reviewer\`.
</system-reminder>`,
};

// ---------------------------------------------------------------------------
// Plugin
// ---------------------------------------------------------------------------

export const GuardrailsPlugin: Plugin = async () => {
  return {
    // -----------------------------------------------------------------------
    // Track agent ↔ session mapping
    //
    // chat.message fires as soon as a user message is received (before the
    // first prompt build), closing the first-turn gap where
    // experimental.chat.messages.transform would otherwise run before
    // chat.params has populated the map.
    // -----------------------------------------------------------------------
    "chat.message": async (input, output) => {
      // A new real user message means a failed compaction cannot suppress the
      // next turn indefinitely. The resolved output message is authoritative:
      // input.agent is optional and can differ from the selected primary agent.
      compactingSessions.delete(input.sessionID);
      sessionAgentMap.set(input.sessionID, output.message.agent);
    },

    "chat.params": async (input) => {
      if (input.agent === "compaction") {
        compactingSessions.add(input.sessionID);
        return;
      }
      sessionAgentMap.set(input.sessionID, input.agent);
    },

    "experimental.session.compacting": async (input) => {
      compactingSessions.add(input.sessionID);
    },

    "experimental.compaction.autocontinue": async (input) => {
      compactingSessions.delete(input.sessionID);
    },

    "event": async (input) => {
      if (input.event.type === "session.compacted") {
        compactingSessions.delete(input.event.properties.sessionID);
      }
    },

    // -----------------------------------------------------------------------
    // Pre-execution guardrails
    // -----------------------------------------------------------------------
    "tool.execute.before": async (input, output) => {
      // --- 1. Subagent nesting prevention ---
      if (input.tool === "task") {
        const agent = sessionAgentMap.get(input.sessionID);
        if (agent && SUBAGENTS.has(agent)) {
          throw new Error(
            `Subagent "${agent}" cannot spawn other subagents via the task tool. ` +
              `You must do the work yourself directly — use read, grep, glob, lsp, bash, and other tools instead.`,
          );
        }
      }

      // --- 2. Orchestration skill blocking for subagents ---
      if (input.tool === "skill") {
        const skillName: unknown = output.args?.name;
        const agent = sessionAgentMap.get(input.sessionID);
        if (
          agent &&
          SUBAGENTS.has(agent) &&
          typeof skillName === "string" &&
          SUBAGENT_BLOCKED_SKILLS.has(skillName)
        ) {
          throw new Error(
            `[Guardrail] Subagent "${agent}" cannot load skill "${skillName}". ` +
              `This is an orchestration skill reserved for the main agent. ` +
              `Execute your assigned task directly. DO NOT attempt to read the skill file manually.`,
          );
        }
      }

      // --- 3. LSP-first enforcement ---
      if (input.tool === "grep" || input.tool === "glob") {
        const pattern: unknown = output.args?.pattern;
        if (typeof pattern === "string" && SYMBOL_DEFINITION_RE.test(pattern)) {
          const include: unknown = output.args?.include;
          if (
            includeTargetsLspFiles(
              typeof include === "string" ? include : undefined,
            )
          ) {
            throw new Error(
              `Symbol search detected: "${pattern}". ` +
                `Use LSP tools instead — goToDefinition, findReferences, hover, documentSymbol, workspaceSymbol. ` +
                `Grep/glob is only for string literals, comments, regex patterns, or non-code files. ` +
                `Searching Python? basedpyright's workspaceSymbol/findReferences are broken, so grep IS ` +
                `the documented fallback — add include="*.py" to bypass this guard. ` +
                `See AGENTS.md for the full LSP-first policy.`,
            );
          }
        }
      }

      // --- 4. Plan-mode output-redirect blocking ---
      if (input.tool === "bash" || input.tool === "shell") {
        const agent = sessionAgentMap.get(input.sessionID);
        if (agent === "plan") {
          const command: unknown = output.args?.command;
          if (typeof command === "string" && OUTPUT_REDIRECT_RE.test(command)) {
            throw new Error(
              `[Guardrail] Output redirection is blocked in plan mode (read-only). ` +
                `The permission matcher cannot see redirects, so this guard enforces edit:deny. ` +
                `If the ">" is part of a quoted string, rephrase the command without it.`,
            );
          }
        }
      }

      // --- 5. Hardware-key signing-disable guard ---
      if (input.tool === "bash" || input.tool === "shell") {
        const command: unknown = output.args?.command;
        if (typeof command === "string" && detectSigningDisable(command)) {
          throw new Error(
            `[Guardrail] Git signing-disable command blocked: this is a deliberate guardrail against ` +
              `bypassing a hardware-key touch failure. If an unsigned commit is genuinely intended, ` +
              `the user should run it themselves outside the agent.`,
          );
        }
      }
    },

    // -----------------------------------------------------------------------
    // Post-execution hardware-key retry advisory
    // -----------------------------------------------------------------------
    "tool.execute.after": async (input, output) => {
      if (input.tool !== "bash" && input.tool !== "shell") return;

      const command: unknown = input.args?.command;
      if (typeof command !== "string" || typeof output.output !== "string") return;

      if (detectHardwareKeyFailure(command, output.output, output.metadata)) {
        output.output = `${buildHardwareKeyRetryDirective()}\n\n${output.output}`;
      }
    },

    // -----------------------------------------------------------------------
    // 6. Skill activation nudges (once per session per skill)
    // 7. Subagent dispatch reminders (every prompt build, plan/build only)
    // -----------------------------------------------------------------------
    "experimental.chat.messages.transform": async (_input, output) => {
      const messages = output.messages;
      if (!messages || messages.length === 0) return;

      // Locate the latest user message (shared by both concerns below)
      let lastUserMsg: (typeof messages)[number] | undefined;
      for (let i = messages.length - 1; i >= 0; i--) {
        if (messages[i].info.role === "user") {
          lastUserMsg = messages[i];
          break;
        }
      }
      if (!lastUserMsg || lastUserMsg.parts.length === 0) return;

      const sessionID = lastUserMsg.info.sessionID;
      if (compactingSessions.has(sessionID)) return;

      const refPart = lastUserMsg.parts[0];
      const appendReminder = (text: string) => {
        // Hook contract is mutate-in-place; idempotency guards below prevent
        // duplication when an already-transformed array re-enters the hook.
        const part = { ...refPart, type: "text", text } as any;
        lastUserMsg!.parts.push(part);
        return part;
      };

      // --- 6. Skill activation nudges ---
      let latestUserText = "";
      for (const part of lastUserMsg.parts) {
        if (part.type === "text") {
          latestUserText += " " + (part as any).text;
        }
      }

      if (latestUserText.trim() && sessionID) {
        if (!nudgedSkills.has(sessionID)) {
          nudgedSkills.set(sessionID, new Set());
        }
        const nudged = nudgedSkills.get(sessionID)!;

        const newNudges: string[] = [];
        for (const trigger of SKILL_TRIGGERS) {
          if (nudged.has(trigger.skill)) continue;
          const matched = trigger.patterns.some((p) => p.test(latestUserText));
          if (matched) {
            nudged.add(trigger.skill);
            newNudges.push(`- **${trigger.skill}**: ${trigger.nudge}`);
          }
        }

        if (newNudges.length > 0) {
          appendReminder(
            `<system-reminder>\nSkill activation reminder (auto-detected from context):\n` +
              newNudges.join("\n") +
              `\nInvoke these skills using the skill tool if you haven't already.\n</system-reminder>`,
          );
        }
      }

      // --- 7. Subagent dispatch reminder (plan/build agents only) ---
      // Transform routing is always determined by the latest required resolved
      // user agent. The session map is reserved for tool guards because it can
      // temporarily hold internal agents such as title or summary.
      const agent =
        lastUserMsg.info.role === "user" ? lastUserMsg.info.agent : undefined;
      const dispatchReminder = agent ? DISPATCH_REMINDERS[agent] : undefined;
      if (!dispatchReminder) return;

      // Idempotency applies only to a reminder this plugin inserted into this
      // in-memory array; user-authored marker text must not suppress injection.
      const alreadyInjected = lastUserMsg.parts.some(
        (part) => injectedPrimaryReminderParts.has(part),
      );
      if (alreadyInjected) return;

      injectedPrimaryReminderParts.add(appendReminder(dispatchReminder));
    },
  };
};
