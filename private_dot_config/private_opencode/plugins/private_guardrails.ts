import type { Plugin } from "@opencode-ai/plugin";

/**
 * Guardrails plugin for OpenCode.
 *
 * Enforces four operational disciplines:
 *   1. Subagent nesting prevention — blocks subagents from spawning subagents
 *   2. Orchestration skill blocking — prevents subagents from loading dispatch-heavy skills
 *   3. LSP-first enforcement — blocks grep/glob for symbol-like patterns
 *   4. Skill activation nudges — reminds the model to invoke relevant skills
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
 * Matches:  "class Foo", "def bar", "function baz", "interface Qux"
 * Skips:    "error in class handling", "undefined function call"
 */
const SYMBOL_DEFINITION_RE =
  /^\s*\b(class|def|function|func|interface|struct|type|enum|impl|trait|module|package)\s+\w+/;

/**
 * File extensions for which LSP servers are typically available.
 * If the grep `include` filter targets only non-LSP files, we let it through.
 */
const LSP_EXTENSIONS = new Set([
  ".py",
  ".pyi", // basedpyright
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
// Plugin
// ---------------------------------------------------------------------------

export const GuardrailsPlugin: Plugin = async () => {
  return {
    // -----------------------------------------------------------------------
    // Track agent ↔ session mapping
    // -----------------------------------------------------------------------
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
                `See AGENTS.md for the full LSP-first policy.`,
            );
          }
        }
      }
    },

    // -----------------------------------------------------------------------
    // Skill activation nudges (once per session per skill)
    // -----------------------------------------------------------------------
    "experimental.chat.messages.transform": async (_input, output) => {
      // Find the most recent user message to scan for skill triggers
      const messages = output.messages;
      if (!messages || messages.length === 0) return;

      // Walk backwards to find the latest user message
      let latestUserText = "";
      let sessionID = "";
      for (let i = messages.length - 1; i >= 0; i--) {
        const msg = messages[i];
        if (msg.info.role === "user") {
          sessionID = msg.info.sessionID;
          for (const part of msg.parts) {
            if (part.type === "text") {
              latestUserText += " " + (part as any).text;
            }
          }
          break;
        }
      }

      if (!latestUserText.trim() || !sessionID) return;

      // Initialize nudge tracking for this session
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

      if (newNudges.length === 0) return;

      // Inject the nudge directly into the latest user message as a system-reminder
      // This ensures the model sees it in context right before generating a response.
      const lastUserMsg = [...messages]
        .reverse()
        .find((m) => m.info.role === "user");
      if (lastUserMsg && lastUserMsg.parts.length > 0) {
        const reminderText =
          `<system-reminder>\nSkill activation reminder (auto-detected from context):\n` +
          newNudges.join("\n") +
          `\nInvoke these skills using the skill tool if you haven't already.\n</system-reminder>`;

        // Append as a new text part to the user message
        const refPart = lastUserMsg.parts[0];
        lastUserMsg.parts.push({
          ...refPart,
          type: "text",
          text: reminderText,
        } as any);
      }
    },
  };
};
