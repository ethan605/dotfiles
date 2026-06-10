import type { Plugin } from "@opencode-ai/plugin";

/**
 * Guardrails plugin for OpenCode.
 *
 * Enforces six operational disciplines:
 *   1. Subagent nesting prevention — blocks subagents from spawning subagents
 *   2. Orchestration skill blocking — prevents subagents from loading dispatch-heavy skills
 *   3. LSP-first enforcement — blocks grep/glob for symbol-like patterns
 *   4. Plan-mode redirect blocking — blocks output redirects that bypass edit:deny
 *   5. Skill activation nudges — reminds the model to invoke relevant skills
 *   6. Subagent dispatch reminders — per-turn reminder keeping plan/build agents
 *      on the explore → implement → review dispatch loop
 *
 * Works alongside the superpowers bootstrap and rtk plugins.
 */

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/** Maps sessionID → agent name. Populated from chat.params. */
const sessionAgentMap = new Map<string, string>();

/** Maps sessionID → set of skill names already nudged. One nudge per skill per session. */
const nudgedSkills = new Map<string, Set<string>>();

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
 * Known gap (accepted, self-healing): on a resumed session that continues
 * WITHOUT a new user message (e.g. auto-continue after compaction right
 * after an opencode restart), sessionAgentMap is empty and the reminder is
 * skipped for that one turn. It resumes on the next user message.
 *
 * Thresholds are taxonomy-based (task kind), NOT line counts — line-count
 * thresholds incentivize code-golfing to dodge dispatch.
 */
const DISPATCH_REMINDER_MARKER = "<dispatch-reminder>";

const DISPATCH_REMINDERS: Record<string, string> = {
  build: `<system-reminder>
${DISPATCH_REMINDER_MARKER}
Dispatch policy (primary agent): default loop is explore → \`general\` implements → \`reviewer\` reviews → repeat until greenlight.
- Dispatch \`explore\`: understanding unfamiliar code, multi-file analysis, locating implementations.
- Dispatch \`general\`: feature additions, logic changes, refactors, multi-file changes, anything requiring tests.
- Dispatch \`reviewer\`: after ANY completed implementation or refactor, BEFORE claiming done.
Direct work is allowed ONLY for: typo/string fixes in known locations, config tweaks, running verification commands, or when the user explicitly tells you to do it yourself.
</system-reminder>`,
  plan: `<system-reminder>
${DISPATCH_REMINDER_MARKER}
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
    "chat.message": async (input) => {
      if (input.agent) sessionAgentMap.set(input.sessionID, input.agent);
    },

    "chat.params": async (input) => {
      sessionAgentMap.set(input.sessionID, input.agent);
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
    },

    // -----------------------------------------------------------------------
    // 5. Skill activation nudges (once per session per skill)
    // 6. Subagent dispatch reminders (every prompt build, plan/build only)
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
      const refPart = lastUserMsg.parts[0];
      const appendReminder = (text: string) => {
        // Hook contract is mutate-in-place; idempotency guards below prevent
        // duplication when an already-transformed array re-enters the hook.
        lastUserMsg!.parts.push({ ...refPart, type: "text", text } as any);
      };

      // --- 5. Skill activation nudges ---
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

      // --- 6. Subagent dispatch reminder (plan/build agents only) ---
      const agent = sessionAgentMap.get(sessionID);
      const dispatchReminder = agent ? DISPATCH_REMINDERS[agent] : undefined;
      if (!dispatchReminder) return;

      // Idempotency guard: skip if this in-memory message already carries the
      // reminder (opencode may pass an already-transformed array through the
      // hook again — same pattern the superpowers bootstrap guards against).
      const alreadyInjected = lastUserMsg.parts.some(
        (p) =>
          p.type === "text" &&
          typeof (p as any).text === "string" &&
          (p as any).text.includes(DISPATCH_REMINDER_MARKER),
      );
      if (alreadyInjected) return;

      appendReminder(dispatchReminder);
    },
  };
};
