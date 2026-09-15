import type { Plugin } from "@opencode-ai/plugin";

/**
 * Guardrails plugin for OpenCode.
 *
 * Enforces seven operational disciplines:
 *   1. Subagent nesting prevention — blocks subagents from spawning subagents
 *   2. Orchestration skill blocking — prevents subagents from loading dispatch-heavy skills
 *   3. LSP-first enforcement — blocks grep/glob for symbol-like patterns
 *   4. Plan-mode redirect blocking — blocks output redirects that bypass edit approval
 *   5. Git write-confirmation gate — blocks every git operation that can
 *      modify the working tree, history, or remotes until the user confirms
 *      the exact command via the question tool (one approval per command,
 *      every time); includes a signing-disable guard as defense-in-depth
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

type GitWriteApprovalState = "pending" | "approved";
/** sessionID → (raw command string → state). Raw string = exact bash tool arg. */
const gitWriteApprovals = new Map<string, Map<string, GitWriteApprovalState>>();
const MAX_PENDING_GIT_WRITE_COMMANDS = 32; // per session
const MAX_GIT_WRITE_SESSIONS = 64;         // total tracked sessions

/**
 * Flips every pending git-write approval for the session to approved.
 * No-op when the session has no pending commands.
 */
function approvePendingGitWrites(sessionID: string): void {
  const perSession = gitWriteApprovals.get(sessionID);
  if (!perSession) return;
  for (const [command, state] of perSession) {
    if (state === "pending") perSession.set(command, "approved");
  }
}

/**
 * Records a blocked command as pending approval for the session, with FIFO
 * eviction at both caps (Map insertion order provides the FIFO). Re-recording
 * a command that is already pending is a no-op refresh. Eviction failure mode
 * is a safe re-block: an evicted entry simply gates again on the next attempt.
 */
function recordPendingGitWrite(sessionID: string, command: string): void {
  let perSession = gitWriteApprovals.get(sessionID);
  if (!perSession) {
    perSession = new Map();
    gitWriteApprovals.set(sessionID, perSession);
    while (gitWriteApprovals.size > MAX_GIT_WRITE_SESSIONS) {
      const oldestSession = gitWriteApprovals.keys().next().value;
      if (oldestSession === undefined) break;
      gitWriteApprovals.delete(oldestSession);
    }
  }
  if (perSession.get(command) === "pending") return;
  perSession.set(command, "pending");
  while (perSession.size > MAX_PENDING_GIT_WRITE_COMMANDS) {
    const oldestCommand = perSession.keys().next().value;
    if (oldestCommand === undefined) break;
    perSession.delete(oldestCommand);
  }
}

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
 * `ls *` allow rule and writes a file without an edit approval. Plugins see
 * the RAW command string, so we block output redirects here for the plan
 * agent: redirects must not bypass the normal `edit:ask` approval. Build mode
 * keeps legitimate redirects (e.g. `cmd > log 2>&1`).
 *
 * Catches: `>`, `>>`, `2>`, `&>`, `12>` targeting real paths.
 * Ignores: fd-dups (`2>&1`, `>&2`) and `/dev/null|stderr|stdout` sinks.
 * Known false positive: a literal ">" inside quoted arguments (e.g. git
 * pretty-format arrows) throws a recoverable error — acceptable in plan mode.
 */
const OUTPUT_REDIRECT_RE =
  /(?:^|[^<])(?:&|\d+)?>{1,2}(?!&)\s*(?!\/dev\/(null|stderr|stdout)\b)\S/;

// ---------------------------------------------------------------------------
// Git write-confirmation gate and signing-disable config
// ---------------------------------------------------------------------------

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
  "--get-color",
  "--get-colorbool",
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

/**
 * Splits only the shell forms rtk emits: quotes, backslash escapes, and the
 * chain operators &&, ||, ;, and |. Unquoted newlines also separate segments
 * (blank lines are tolerated; a trailing separator is accepted as valid
 * shell). Command substitution and subshells are deliberately unsupported;
 * treating those commands as unclassifiable avoids making an unsafe guess
 * about which git invocation will actually run.
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
    if (character === "\n") {
      finishToken();
      if (tokens.length > 0) {
        segments.push(tokens);
        tokens = [];
      }
      continue; // blank lines are ignored, NOT an error (unlike `;;`)
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
  if (tokens.length > 0) segments.push(tokens);
  // A trailing `;` or newline is valid shell, so classify what came before it
  // instead of returning undefined — undefined would make the NEW gate fail
  // closed (fine) but the signing-disable guard fail OPEN (regression).
  return segments.length > 0 ? segments : undefined;
}

function parseConfigValue(
  value: string | undefined,
): GitConfigValue | undefined {
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

interface ExecutableResolution {
  index: number;                    // index of the executable token (may be >= tokens.length)
  environment: Map<string, string>; // leading AND env-wrapper assignments
}

/**
 * Shared executable normalization for both git guards: skips leading
 * env-assignments and transparent wrappers (env, rtk, command, builtin, time,
 * nice, sudo), returning the executable token index and the collected
 * environment (leading assignments plus the env wrapper's own VAR=value
 * operands — the latter feed hasFalseySigningConfig for --config-env).
 *
 * Documented residual bypasses (accepted, out of scope): `xargs git`,
 * `nohup git`, exotic env/sudo option forms, shell aliases, and scripts
 * invoking git internally.
 */
function resolveExecutable(tokens: string[]): ExecutableResolution {
  const environment = new Map<string, string>();
  let index = 0;
  const readAssignments = () => {
    while (index < tokens.length) {
      const assignment = /^([A-Za-z_][A-Za-z0-9_]*)=(.*)$/.exec(tokens[index]);
      if (!assignment) break;
      environment.set(assignment[1], assignment[2]);
      index++;
    }
  };
  readAssignments();
  let moved = true;
  while (moved && index < tokens.length) {
    moved = false;
    if (tokens[index] === "env") {
      index++;
      while (index < tokens.length && tokens[index].startsWith("-")) {
        if (tokens[index] === "-u" || tokens[index] === "-C") index++; // option operand
        index++;
      }
      readAssignments(); // env's own VAR=value operands are real env for the child
      moved = true;
    }
    if (["rtk", "command", "builtin", "time"].includes(tokens[index])) {
      index++;
      if (tokens[index] === "--") index++; // e.g. `command -- git`
      moved = true;
    }
    if (tokens[index] === "nice") {
      index++;
      if (tokens[index] === "-n") index += 2;
      else if (index < tokens.length && /^-\d+$/.test(tokens[index])) index++;
      moved = true;
    }
    if (tokens[index] === "sudo") {
      index++;
      // Common non-operand flags, then operand-taking flags with their operand.
      while (index < tokens.length && tokens[index].startsWith("-")) {
        if (["-u", "-g", "-h", "-p", "-C", "-T", "-U"].includes(tokens[index])) index++;
        index++;
      }
      moved = true;
    }
  }
  return { index, environment };
}

function parseGitInvocation(tokens: string[]): GitInvocation | undefined {
  const { index, environment } = resolveExecutable(tokens);
  if (tokens[index] !== "git" && !tokens[index]?.endsWith("/git")) return undefined;

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
      const configValue = parseConfigEnvironment(
        token.slice("--config-env=".length),
      );
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

function firstSubcommandArgument(
  invocation: GitInvocation,
): string | undefined {
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

  return !invocation.args
    .slice(invocation.subcommandIndex + 1)
    .some(
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

// ---------------------------------------------------------------------------
// Git write classifier
// ---------------------------------------------------------------------------

interface GitWriteClassification {
  hasGit: boolean;
  isWrite: boolean;
  writeSubcommands: string[];
  unclassifiable: boolean; // tokenizeShell failed AND command mentions git
}

/**
 * Git subcommands that are real reads. Anything not listed here and without a
 * context classifier below is treated as a write — an unknown subcommand or
 * a git alias gates (fail-closed), which also makes a dedicated
 * GIT_WRITE_SUBCOMMANDS set unnecessary. fsck and archive are deliberately
 * NOT here: they have write-capable options, see the context classifiers.
 */
const GIT_READ_SUBCOMMANDS = new Set([
  "status",
  "diff",
  "log",
  "show",
  "describe",
  "rev-parse",
  "rev-list",
  "blame",
  "annotate",
  "shortlog",
  "merge-base",
  "cat-file",
  "ls-files",
  "ls-tree",
  "for-each-ref",
  "show-branch",
  "show-ref",
  "whatchanged",
  "name-rev",
  "check-ignore",
  "check-attr",
  "check-ref-format",
  "check-mailmap",
  "verify-commit",
  "verify-tag",
  "verify-pack",
  "count-objects",
  "grep",
  "help",
  "version",
  "range-diff",
  "difftool",
  "diff-index",
  "diff-tree",
  "diff-files",
  "var",
  "stripspace",
]);

const BRANCH_MUTATION_FLAGS = new Set([
  "-d",
  "-D",
  "--delete",
  "-m",
  "-M",
  "--move",
  "-c",
  "-C",
  "--copy",
  "-u",
  "--set-upstream-to",
  "--unset-upstream",
  "--edit-description",
  "--track",
  "-t",
]);

const BRANCH_LIST_FLAGS = new Set([
  "-l",
  "--list",
  "-a",
  "--all",
  "-r",
  "--remotes",
  "-v",
  "-vv",
  "--verbose",
  "--show-current",
  "--contains",
  "--no-contains",
  "--merged",
  "--no-merged",
  "--points-at",
  "--format",
  "--sort",
  "-i",
  "--ignore-case",
  "--column",
  "--no-column",
]);

/** Short-cluster characters (e.g. `-av`) that count as list evidence. */
const BRANCH_SHORT_LIST_CHARS = new Set(["a", "r", "v", "l"]);
/** Short-cluster characters (e.g. `-D`) that mutate branches. */
const BRANCH_SHORT_MUTATION_CHARS = new Set([
  "d",
  "D",
  "m",
  "M",
  "c",
  "C",
  "u",
  "t",
]);

const TAG_EXTENDED_LIST_FLAGS = new Set([
  "--contains",
  "--no-contains",
  "--merged",
  "--no-merged",
  "--points-at",
  "--format",
  "--sort",
  "--column",
  "--no-column",
  "-i",
  "--ignore-case",
]);

const SYMBOLIC_REF_WRITE_FLAGS = new Set([
  "-d",
  "--delete",
  "-m",
  "--no-deref",
  "--stdin",
]);

const UPDATE_REF_WRITE_FLAGS = new Set([
  "-d",
  "--delete",
  "--stdin",
  "--no-deref",
  "-z",
]);

const REPLACE_WRITE_FLAGS = new Set([
  "-d",
  "--delete",
  "--edit",
  "--graft",
  "--convert-graft-file",
]);

const GIT_CONFIG_WRITE_FLAGS = new Set([
  "--unset",
  "--unset-all",
  "--add",
  "--replace-all",
  "--rename-section",
  "--remove-section",
  "-e",
  "--edit", // opens an editor that can modify config
]);

/**
 * Read iff no mutation flag AND (list evidence OR no positional). Bare
 * `git branch` reads; `git branch x` writes.
 *
 * Known accepted false negative: `git branch --contains HEAD newbr` (invalid
 * git usage in practice) is classified as a read because --contains counts
 * as list evidence.
 */
function branchInvocationIsWrite(invocation: GitInvocation): boolean {
  let hasListEvidence = false;
  let positionalCount = 0;
  let positionalOnly = false;
  for (const token of invocation.args.slice(invocation.subcommandIndex + 1)) {
    if (positionalOnly) {
      positionalCount++;
      continue;
    }
    if (token === "--") {
      positionalOnly = true; // everything after `--` is positional
      continue;
    }
    if (token.startsWith("--")) {
      const name = token.split("=")[0];
      if (BRANCH_MUTATION_FLAGS.has(name)) return true;
      if (BRANCH_LIST_FLAGS.has(name)) hasListEvidence = true;
      continue;
    }
    if (token.startsWith("-") && token.length > 1) {
      const flag = token.slice(1);
      if (
        [...flag].some((character) =>
          BRANCH_SHORT_MUTATION_CHARS.has(character),
        )
      ) {
        return true;
      }
      if (
        [...flag].every((character) => BRANCH_SHORT_LIST_CHARS.has(character))
      ) {
        hasListEvidence = true;
      }
      continue;
    }
    positionalCount++;
  }
  return !hasListEvidence && positionalCount > 0;
}

/**
 * Dedicated tag logic — does NOT reuse isSigningCapableGitInvocation, which
 * returns "write" for bare `git tag` (that helper serves the signing-disable
 * guard and stays untouched). Bare `git tag` LISTS tags and must be a read.
 */
function tagInvocationIsWrite(invocation: GitInvocation): boolean {
  const args = invocation.args.slice(invocation.subcommandIndex + 1);
  const isListEvidence = (token: string): boolean =>
    token === "-l" ||
    token === "--list" ||
    token.startsWith("--list=") ||
    token === "-n" ||
    (token.startsWith("-n") && token.length > 2) ||
    token === "-v" ||
    token === "--verify" ||
    (token.startsWith("--") && TAG_EXTENDED_LIST_FLAGS.has(token.split("=")[0]));
  if (args.some(isListEvidence)) return false;
  if (args.some((token) => token === "-d" || token === "--delete")) return true;
  // `git tag v1` and `git tag -a v1 -m x` create a tag; any positional writes.
  return args.some((token) => !token.startsWith("-"));
}

/**
 * Read iff the first positional is list or show. Bare `git stash` behaves as
 * `git stash push` (a write), so "no positional" writes here — unlike remote,
 * worktree, notes, reflog, bisect, and submodule, whose bare forms read.
 */
function stashInvocationIsWrite(invocation: GitInvocation): boolean {
  const first = firstSubcommandArgument(invocation);
  // Deliberately NOT gated open on undefined: bare `git stash` = push.
  return first !== "list" && first !== "show";
}

/** Absorbs the old network check: remote update/prune are writes. */
function remoteInvocationIsWrite(invocation: GitInvocation): boolean {
  const first = firstSubcommandArgument(invocation);
  return first !== undefined && first !== "show" && first !== "get-url";
}

/**
 * Deliberately parallel to (NOT refactored out of) configWriteDisablesSigning:
 * the two answer different questions (any config write vs. specifically a
 * signing-disable), and keeping them separate avoids coupling the gate to the
 * signing guard's key extraction.
 */
function gitConfigInvocationIsWrite(invocation: GitInvocation): boolean {
  const configArgs = invocation.args.slice(invocation.subcommandIndex + 1);
  if (configArgs.some((arg) => GIT_CONFIG_READ_OPTIONS.has(arg))) return false;
  if (configArgs.some((arg) => GIT_CONFIG_WRITE_FLAGS.has(arg))) return true;

  const positional: string[] = [];
  for (let index = 0; index < configArgs.length; index++) {
    const token = configArgs[index];
    if (GIT_CONFIG_OPTIONS_WITH_OPERAND.has(token)) {
      index++;
      continue;
    }
    if (
      token.startsWith("--file=") ||
      token.startsWith("--blob=") ||
      token.startsWith("--type=") ||
      token.startsWith("--default=")
    ) {
      continue;
    }
    if (token.startsWith("-")) continue;
    positional.push(token);
  }

  const action = positional[0]?.toLowerCase();
  if (action === "get" || action === "list") return false;
  if (
    action === "set" ||
    action === "unset" ||
    action === "unset-all" ||
    action === "add" ||
    action === "rename-section" ||
    action === "remove-section" ||
    action === "edit"
  ) {
    return true;
  }
  // Legacy `git config <key> [<value>]` form: a value operand means a write.
  return positional.length >= 2;
}

function worktreeInvocationIsWrite(invocation: GitInvocation): boolean {
  const first = firstSubcommandArgument(invocation);
  return first !== undefined && first !== "list";
}

/**
 * firstSubcommandArgument cannot be used here: it skips option NAMES but not
 * their OPERANDS, so `git notes --ref foo list` would misread "foo" as the
 * action. Consume `--ref <operand>` / `--ref=<operand>` before the first
 * positional.
 */
function notesInvocationIsWrite(invocation: GitInvocation): boolean {
  const args = invocation.args.slice(invocation.subcommandIndex + 1);
  const positional: string[] = [];
  for (let index = 0; index < args.length; index++) {
    const token = args[index];
    if (token === "--ref") {
      index++; // --ref <operand>
      continue;
    }
    if (token.startsWith("--ref=")) continue;
    if (token.startsWith("-")) continue;
    positional.push(token.toLowerCase());
  }
  const first = positional[0];
  return (
    first !== undefined &&
    first !== "list" &&
    first !== "show" &&
    first !== "get-ref"
  );
}

/** Read iff no write flag AND at most one positional (the query form). */
function symbolicRefInvocationIsWrite(invocation: GitInvocation): boolean {
  let positionalCount = 0;
  for (const token of invocation.args.slice(invocation.subcommandIndex + 1)) {
    if (SYMBOLIC_REF_WRITE_FLAGS.has(token)) return true;
    if (token.startsWith("-")) continue;
    positionalCount++;
  }
  return positionalCount > 1;
}

/** Read iff no write flag AND at most one positional (the query form). */
function updateRefInvocationIsWrite(invocation: GitInvocation): boolean {
  let positionalCount = 0;
  for (const token of invocation.args.slice(invocation.subcommandIndex + 1)) {
    if (UPDATE_REF_WRITE_FLAGS.has(token)) return true;
    if (token.startsWith("-")) continue;
    positionalCount++;
  }
  return positionalCount > 1;
}

function reflogInvocationIsWrite(invocation: GitInvocation): boolean {
  const first = firstSubcommandArgument(invocation);
  return first !== undefined && first !== "show" && first !== "exists";
}

function bisectInvocationIsWrite(invocation: GitInvocation): boolean {
  const first = firstSubcommandArgument(invocation);
  return (
    first !== undefined &&
    !["log", "view", "visualize", "terms"].includes(first)
  );
}

function sparseCheckoutInvocationIsWrite(invocation: GitInvocation): boolean {
  const first = firstSubcommandArgument(invocation);
  return first !== undefined && first !== "list";
}

function submoduleInvocationIsWrite(invocation: GitInvocation): boolean {
  const first = firstSubcommandArgument(invocation);
  return first !== undefined && first !== "status" && first !== "summary";
}

/**
 * Read iff no write flag AND (no positionals OR list evidence). -l/--list can
 * take a pattern operand (`git replace -l 'v*'`), so list evidence must
 * override the positional count, and --format implies the list form.
 */
function replaceInvocationIsWrite(invocation: GitInvocation): boolean {
  let hasListEvidence = false;
  let positionalCount = 0;
  for (const token of invocation.args.slice(invocation.subcommandIndex + 1)) {
    if (REPLACE_WRITE_FLAGS.has(token)) return true;
    if (token === "-l" || token === "--list" || token.startsWith("--format")) {
      hasListEvidence = true;
      continue;
    }
    if (token.startsWith("-")) continue;
    positionalCount++;
  }
  return positionalCount > 0 && !hasListEvidence;
}

/** -w writes the object into the object database; the default only reads. */
function hashObjectInvocationIsWrite(invocation: GitInvocation): boolean {
  return invocation.args
    .slice(invocation.subcommandIndex + 1)
    .includes("-w");
}

/** --lost-found writes .git/lost-found/* objects. */
function fsckInvocationIsWrite(invocation: GitInvocation): boolean {
  return invocation.args
    .slice(invocation.subcommandIndex + 1)
    .includes("--lost-found");
}

/**
 * Every output form writes a file: `-o`, attached `-oFILE` (any arg starting
 * `-o` with length > 2 that isn't `--`-prefixed), `--output`, `--output=...`.
 * The stdout form is read-ish (piped consumers are separate segments).
 */
function archiveInvocationIsWrite(invocation: GitInvocation): boolean {
  return invocation.args
    .slice(invocation.subcommandIndex + 1)
    .some(
      (token) =>
        token === "-o" ||
        (token.startsWith("-o") &&
          token.length > 2 &&
          !token.startsWith("--")) ||
        token === "--output" ||
        token.startsWith("--output="),
    );
}

/**
 * Subcommands whose read/write status depends on their arguments. All
 * classifiers slice args from subcommandIndex + 1, skip flags (consuming
 * operands where the subcommand has operand-taking options), and fail closed
 * on unexpected shapes.
 */
const GIT_CONTEXT_WRITE_SUBCOMMANDS = new Map<
  string,
  (invocation: GitInvocation) => boolean
>([
  ["branch", branchInvocationIsWrite],
  ["tag", tagInvocationIsWrite],
  ["stash", stashInvocationIsWrite],
  ["remote", remoteInvocationIsWrite],
  ["config", gitConfigInvocationIsWrite],
  ["worktree", worktreeInvocationIsWrite],
  ["notes", notesInvocationIsWrite],
  ["symbolic-ref", symbolicRefInvocationIsWrite],
  ["update-ref", updateRefInvocationIsWrite],
  ["reflog", reflogInvocationIsWrite],
  ["bisect", bisectInvocationIsWrite],
  ["replace", replaceInvocationIsWrite],
  ["sparse-checkout", sparseCheckoutInvocationIsWrite],
  ["hash-object", hashObjectInvocationIsWrite],
  ["submodule", submoduleInvocationIsWrite],
  ["fsck", fsckInvocationIsWrite],
  ["archive", archiveInvocationIsWrite],
]);

/**
 * Read whitelist → context classifier → fail-closed true: an unknown
 * subcommand or a git alias gates.
 */
function gitInvocationIsWrite(invocation: GitInvocation): boolean {
  if (invocation.subcommand === undefined) return false;
  if (GIT_READ_SUBCOMMANDS.has(invocation.subcommand)) return false;
  const contextClassifier = GIT_CONTEXT_WRITE_SUBCOMMANDS.get(
    invocation.subcommand,
  );
  if (contextClassifier) return contextClassifier(invocation);
  return true;
}

/**
 * Shell-launcher detection for the write gate, run on the RESOLVED executable
 * token (so `FOO=1 /bin/sh -c ...` and `env FOO=1 sh -lc ...` are caught).
 * The inner command is a single quoted token; recursive parsing is out of
 * scope, so ANY `sh -c <token mentioning git>` is gated conservatively —
 * including inner reads. Quoted literals like `echo "git commit"` are safe
 * (single token ≠ bare git, and echo is not a launcher).
 */
function shellLauncherMentionsGit(segment: string[]): boolean {
  const { index } = resolveExecutable(segment);
  const executable = segment[index];
  if (executable === undefined) return false;
  const isLauncher =
    executable === "sh" ||
    executable === "bash" ||
    executable === "zsh" ||
    executable === "dash" ||
    /\/(sh|bash|zsh|dash)$/.test(executable);
  if (!isLauncher) return false;
  for (
    let flagIndex = index + 1;
    flagIndex + 1 < segment.length;
    flagIndex++
  ) {
    const token = segment[flagIndex];
    if (token === "-c" || /^-[a-z]*c[a-z]*$/.test(token)) {
      if (/\bgit\b/.test(segment[flagIndex + 1])) return true;
    }
  }
  return false;
}

function classifyGitWrite(command: string): GitWriteClassification {
  const segments = tokenizeShell(command);
  if (!segments) {
    // Fail closed: any unparseable command mentioning git is gated.
    const mentionsGit = /\bgit\b/.test(command);
    return {
      hasGit: mentionsGit,
      isWrite: mentionsGit,
      writeSubcommands: mentionsGit ? ["<unparseable>"] : [],
      unclassifiable: mentionsGit,
    };
  }

  const writeSubcommands: string[] = [];
  const invocations: GitInvocation[] = [];
  for (const segment of segments) {
    if (shellLauncherMentionsGit(segment)) {
      writeSubcommands.push("<sh -c>");
      continue;
    }
    // parseGitInvocation (NOT parseGitInvocations) distinguishes "no git"
    // from "unparseable"; it re-runs resolveExecutable internally — a
    // harmless duplicate pure computation, one normalization path either way.
    const invocation = parseGitInvocation(segment);
    if (!invocation) continue;
    invocations.push(invocation);
    if (gitInvocationIsWrite(invocation)) {
      writeSubcommands.push(invocation.subcommand ?? "<git>");
    }
  }

  // An `sh -c` hit gates even though it yields no GitInvocation, so isWrite
  // derives from writeSubcommands alone.
  return {
    hasGit: invocations.length > 0 || writeSubcommands.length > 0,
    isWrite: writeSubcommands.length > 0,
    writeSubcommands,
    unclassifiable: false,
  };
}

function buildGitWriteGateError(
  command: string,
  classification: GitWriteClassification,
  agent?: string,
): string {
  const body = `[Guardrail] Git write operation blocked — explicit user confirmation required.

Blocked command:
  ${command}

Detected git write operation(s): ${classification.writeSubcommands.join(", ")}.

Every git command that can modify the working tree, history, or a remote
(including add/commit/reset/checkout/stash/config-writes/push/fetch) must be
explicitly confirmed by the user BEFORE it runs — every time, no exceptions.
This also guarantees the user is present to touch their hardware security key
when the operation is signed.

Recovery procedure — follow EXACTLY:
1. Call the \`question\` tool and ask the user for permission, quoting the
   blocked command above verbatim in the question. Answering in chat text
   does NOT unlock the command — confirmation must go through the question
   tool.
2. If the user declines or does not answer, do NOT run the command. Report it
   back as blocked instead.
3. If the user approves, retry the EXACT SAME command string — character for
   character. Do NOT reword it, add or remove flags, reorder it, split it into
   pieces, or wrap it (e.g. in rtk or env-var prefixes). A different string is
   a different command and will be blocked again.
4. The approval is one-shot: this exact command will be allowed to run exactly
   once. A later identical command requires fresh confirmation.
5. Be ready: if this command signs (commit, merge, tag, rebase, push), the
   user may need to touch their hardware security key the MOMENT it runs —
   remind them in your question.
6. Planning ahead: if you already know you need SEVERAL git writes (e.g.
   add + commit + push), run them as ONE chained command joined with && so
   the user confirms a single time. This never applies to THIS blocked
   command — it must be retried exactly as-is (see step 3).`;

  const suffixes: string[] = [];
  if (classification.unclassifiable) {
    suffixes.push(
      `This command could not be parsed safely; any unparseable command ` +
        `mentioning git is blocked conservatively. Rewrite it in a simpler ` +
        `form (a single plain command, no command substitution or subshells) ` +
        `and try again.`,
    );
  }
  if (agent !== undefined && SUBAGENTS.has(agent)) {
    suffixes.push(
      `You are running as a subagent: if the question tool cannot reach the ` +
        `user, STOP — do not attempt any workaround. Include the blocked ` +
        `command above verbatim in your report back to the primary agent.`,
    );
  }
  return suffixes.length > 0 ? `${body}\n\n${suffixes.join("\n\n")}` : body;
}

function isFalseyGitConfigValue(value: string | undefined): boolean {
  return (
    value !== undefined &&
    ["false", "off", "no", "0"].includes(value.toLowerCase())
  );
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
        isFalseyGitConfigValue(
          invocation.environment.get(config.environmentName),
        ),
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
    if (
      token.startsWith("--file=") ||
      token.startsWith("--blob=") ||
      token.startsWith("--type=")
    ) {
      continue;
    }
    if (token.startsWith("-")) continue;
    positional.push(token);
  }

  const action = positional[0]?.toLowerCase();
  if (action === "get" || action === "list") return false;

  const usesModernSet = action === "set";
  const usesModernUnset = action === "unset" || action === "unset-all";
  const key =
    positional[usesModernSet || usesModernUnset ? 1 : 0]?.toLowerCase();
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
 * opencode itself uses for the (empirically reliable) plan-mode workflow
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
const USE_RADIO_4_ENGLISH = false;
const PRIMARY_AGENT_TURN_REMINDER_MARKER = "<primary-agent-turn-reminder>";

const PRIMARY_AGENT_TURN_REMINDER = USE_RADIO_4_ENGLISH
  ? "Primary-agent turn start: Before any response or action on this turn, invoke `radio-4-english` once. If it has already been invoked for this turn, do not invoke it again. Invoke every applicable Superpowers skill alongside it. `radio-4-english` governs prose style only; it supplements and never replaces workflow/process skills."
  : "";

const DISPATCH_REMINDERS: Record<string, string> = {
  build: `<system-reminder>
${PRIMARY_AGENT_TURN_REMINDER_MARKER}
${PRIMARY_AGENT_TURN_REMINDER}
Dispatch policy (primary agent): default loop is explore → \`general\` implements → \`reviewer\` reviews → repeat until greenlight.
- Dispatch \`explore\` for unfamiliar code, multi-file analysis, and locating implementations.
- Dispatch \`general\` for implementation, web research, and multi-step debugging. Parallelise independent tasks only; SAME-FILE tasks run sequentially. Use worktrees only for isolated parallel work.
- Verify before done: run relevant tests, type checks, lint, and build; use actual output as evidence.
- Dispatch \`reviewer\` after every implementation or refactor, BEFORE claiming done.
- Report blockers and material detours promptly. Route scope or design problems back to \`plan\`; do not improvise them.
Direct work is allowed ONLY for: known typo/string fixes, config tweaks, running verification commands, reading 1–3 known files, or explicit user instruction.
</system-reminder>`,
  plan: `<system-reminder>
${PRIMARY_AGENT_TURN_REMINDER_MARKER}
${PRIMARY_AGENT_TURN_REMINDER}
Planning policy: research via \`explore\` dispatches — do not bulk-read the codebase yourself. Reserve direct reads for 1–3 specific files you already know. Build a correct, robust masterplan; assign implementation to \`general\` and reviews to \`reviewer\`. Dispatch \`reviewer\` for sign-off on the draft plan before \`plan_exit\`. The harness supplies the plan workflow and plan-file path: follow them. The plan file is the intended edit target; other edits require approval.
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

    event: async (input) => {
      if (input.event.type === "session.compacted") {
        compactingSessions.delete(input.event.properties.sessionID);
        // Approval state deliberately survives compaction — it's a
        // real-world fact, not a session restart.
      }
      // Unlike session.compacted (properties.sessionID), session.deleted
      // carries its id at properties.info.id (verified against SDK types).
      if (input.event.type === "session.deleted") {
        gitWriteApprovals.delete(input.event.properties.info.id);
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
              `[Guardrail] Output redirection is blocked in plan mode. ` +
                `The permission matcher cannot see redirects, so this guard prevents redirects from bypassing edit approval. ` +
                `If the ">" is part of a quoted string, rephrase the command without it.`,
            );
          }
        }
      }

      // --- 5a. Signing-disable guard ---
      // Unconditional and non-approvable: throws before the gate below so the
      // user is never asked to approve something the plugin will never allow.
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

      // --- 5b. Git write-confirmation gate ---
      // Blocks every git write on first attempt; the exact same command
      // string is allowed exactly once after the user answers a question-tool
      // prompt, then the gate re-arms.
      if (input.tool === "bash" || input.tool === "shell") {
        const command: unknown = output.args?.command;
        if (typeof command === "string") {
          const classification = classifyGitWrite(command);
          if (classification.isWrite) {
            const perSession = gitWriteApprovals.get(input.sessionID);
            if (perSession?.get(command) === "approved") {
              perSession.delete(command); // one-shot: consume, re-arm
            } else {
              recordPendingGitWrite(input.sessionID, command);
              throw new Error(
                buildGitWriteGateError(
                  command,
                  classification,
                  sessionAgentMap.get(input.sessionID),
                ),
              );
            }
          }
        }
      }
    },

    // -----------------------------------------------------------------------
    // Post-execution question-tool attention signal
    //
    // Sole approval signal for the git write gate: the question tool
    // completing in the same session. Verified against OpenCode 1.18.30:
    // every registry tool (question included) is wrapped with
    // tool.execute.before → execute → tool.execute.after, and the question
    // tool resolves after the user answers. chat.message is deliberately NOT
    // an approval signal — a plain user message cannot be tied to consent for
    // a specific command.
    // -----------------------------------------------------------------------
    "tool.execute.after": async (input) => {
      if (input.tool === "question") {
        approvePendingGitWrites(input.sessionID);
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
      if (USE_RADIO_4_ENGLISH) {
        const agent =
          lastUserMsg.info.role === "user" ? lastUserMsg.info.agent : undefined;
        const dispatchReminder = agent ? DISPATCH_REMINDERS[agent] : undefined;
        if (!dispatchReminder) return;

        // Idempotency applies only to a reminder this plugin inserted into this
        // in-memory array; user-authored marker text must not suppress injection.
        const alreadyInjected = lastUserMsg.parts.some((part) =>
          injectedPrimaryReminderParts.has(part),
        );
        if (alreadyInjected) return;

        injectedPrimaryReminderParts.add(appendReminder(dispatchReminder));
      }
    },
  };
};
