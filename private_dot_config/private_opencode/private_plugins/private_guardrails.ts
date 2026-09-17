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
const MAX_GIT_WRITE_SESSIONS = 64; // total tracked sessions

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

/**
 * Shell-structural residue that makes a statically-seen config key or value
 * unknowable: expansion characters (`$`, backtick, parens, braces — content
 * of a QUOTED expansion, which the tokenizer keeps as literal token text)
 * or a backslash (ANSI-C `$'…'` escape kept literally, e.g. the `\x3d` that
 * hides the `=` in `$'commit.gpgsign\x3d0'`). Any hit on a gpgsign-relevant
 * config operand fails closed to "signing disable" — a legitimate gpgsign
 * value is always a clean boolean-ish literal, so this only over-blocks
 * pathological commands.
 */
const CONFIG_UNKNOWABLE_RESIDUE_RE = /[$`(){}'"\\]/;

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
 * Matches whitespace that is NOT shell IFS whitespace (space, tab, LF).
 * JavaScript's `\s` also matches CR and Unicode whitespace (NBSP U+00A0,
 * U+2000–U+200A, U+2028/U+2029, U+202F, U+205F, U+3000, U+FEFF, …), but
 * shells field-split ONLY on IFS whitespace — a tokenizer splitting on
 * anything else diverges from the shell and can be bypassed (round-6
 * finding B3: `git tag --format=x<NBSP>-l v1` tokenized as a read while
 * zsh/bash passed `--format=x<NBSP>-l` as ONE argument, making git CREATE
 * tag `v1`; round-7 residual: CR — bash/zsh keep a bare `\r` INSIDE words,
 * it is not an IFS separator, so `git tag --format=x<CR>-l v1` passed one
 * `--format=x\r-l` argument and CREATED `v1` while the tokenizer split at
 * the CR, saw `-l`, and misclassified READ).
 * Legit commands essentially never contain these characters, so treating
 * any hit as untrustworthy costs ~zero false positives.
 */
const EXOTIC_WHITESPACE_RE = /[^\S \t\n]/;

function containsExoticWhitespace(command: string): boolean {
  return EXOTIC_WHITESPACE_RE.test(command);
}

/**
 * Strips backslash escapes the way the shell does outside quotes (`g\it`
 * runs as `git`). Applied to the RAW command for git-mention tests so
 * escaped-executable/`g\pg\sign`-style tricks cannot evade them. De-escaping
 * inside single quotes is technically wrong, but it can only CREATE false
 * git mentions — the fail-closed direction — and it is only ever used on
 * commands that are gated or raw-signal-checked regardless.
 */
function deEscapeShell(command: string): string {
  return command.replace(/\\(.)/g, "$1");
}

/**
 * Characters that can follow an unquoted `$` and still form an expansion —
 * a parameter name (`$VAR`, `$1`), a brace expansion (`${…}`), or a special
 * parameter (`$@ $* $# $? $$ $! $-`). A `$` before anything else (end of
 * string, whitespace, `.`, `/`, `>` …) is a literal dollar sign in every
 * POSIX shell, so it sets no flag and the command stays classifiable
 * (e.g. `git log --grep="v1$"`).
 */
const UNQUOTED_DOLLAR_EXPANSION_FOLLOW_RE = /[A-Za-z0-9_@*#?!{$-]/;

interface ShellTokenization {
  segments: string[][] | undefined;
  /** True when a parseable command contains an unquoted `$…` expansion. */
  containsUnquotedExpansion: boolean;
}

/**
 * Splits only the shell forms rtk emits: quotes (including ANSI-C `$'…'` and
 * locale `$"…"`, which open exactly like `'…'` / `"…"`), backslash escapes,
 * and the chain operators &&, ||, ;, and |. Field splitting uses ONLY the
 * shell's IFS whitespace (space, tab, newline) — see EXOTIC_WHITESPACE_RE
 * for why any other `\s` character (including CR: bash/zsh keep a bare `\r`
 * inside words) makes the command unclassifiable instead of split. Unquoted
 * newlines also separate segments (blank lines are tolerated; a trailing
 * separator is accepted as valid shell).
 *
 * Unquoted command substitution (`$(…)`), backticks, subshells, and any
 * unquoted paren make the whole command unparseable (segments: undefined);
 * treating those commands as unclassifiable avoids making an unsafe guess
 * about which git invocation will actually run. QUOTED expansions
 * (`"$(…)"`, `` `…` `` inside quotes) are deliberately kept as literal token
 * content instead: a quoted expansion always yields exactly ONE word, so
 * the classifier can treat it as a single opaque positional — the
 * fail-closed direction — rather than refusing the whole command (round 8,
 * B5: `git commit -m "$(date)"` must stay a classifiable commit write).
 *
 * ANSI-C `$'…'` content is kept literally WITHOUT processing its backslash
 * escapes: the option text of a disable attempt survives verbatim
 * (`$'--no-gpg-sign'` → `--no-gpg-sign`, caught by the anchored disable
 * regexes), and residual escapes (`$'commit.gpgsign\x3d0'`) fail closed via
 * the config-operand residue check in parseGitInvocation.
 *
 * `containsUnquotedExpansion` flags unquoted `$…` expansions in an otherwise
 * parseable command (`git tag $X`, `git${IFS}tag`): word splitting and the
 * expanded value are both statically unknowable, so the write gate treats
 * such commands as unclassifiable (round 8, B5.2).
 */
function tokenizeShellDetailed(command: string): ShellTokenization {
  // B3 fail-closed: exotic whitespace means token boundaries here can
  // diverge from the shell's, so no token-based classification is safe.
  // Both consumers handle undefined: the write gate blocks any git-mentioning
  // command (classifyGitWrite), and detectSigningDisable applies its own
  // raw-signal fail-closed check before ever reaching this parser.
  if (containsExoticWhitespace(command)) {
    return { segments: undefined, containsUnquotedExpansion: false };
  }
  const failure = (): ShellTokenization => ({
    segments: undefined,
    containsUnquotedExpansion: true,
  });
  const segments: string[][] = [];
  let tokens: string[] = [];
  let current = "";
  let tokenStarted = false;
  let quote: "'" | '"' | undefined;
  let containsUnquotedExpansion = false;

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
      // POSIX single quotes preserve every character except their closing
      // quote. This branch also serves $'…' content (see the comment above
      // for why the escapes inside are deliberately not processed).
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
        if (index + 1 >= command.length) return failure();
        current += command[++index];
      } else {
        // Quoted expansions ("$(…)" / "`…`") stay as literal content — one
        // opaque word, fail-closed for the classifiers (round 8, B5).
        current += character;
      }
      continue;
    }

    if (character === "$") {
      const next = command[index + 1];
      if (next === "'" || next === '"') {
        // Round 8 (B6): ANSI-C ($'…') / locale ($"…") quoting — the `$`
        // opens the quote; content handling is the branches above.
        quote = next;
        index++;
        tokenStarted = true;
        continue;
      }
    }
    if (character === "'" || character === '"') {
      quote = character;
      tokenStarted = true;
      continue;
    }
    if (character === "\\") {
      if (index + 1 >= command.length) return failure();
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
    if (character === " " || character === "\t") {
      // Shell IFS whitespace only — never the broader Unicode `\s` set,
      // and never CR (bash/zsh keep `\r` inside words); both are
      // guaranteed unreachable here via containsExoticWhitespace above.
      finishToken();
      continue;
    }
    if (
      character === "`" ||
      character === "(" ||
      character === ")" ||
      (character === "$" && command[index + 1] === "(")
    ) {
      return failure();
    }
    if (
      character === "$" &&
      index + 1 < command.length &&
      UNQUOTED_DOLLAR_EXPANSION_FOLLOW_RE.test(command[index + 1])
    ) {
      // Unquoted $VAR / ${…} / special parameter: statically unknowable →
      // flag for the write gate's B5.2 unclassifiable branch.
      containsUnquotedExpansion = true;
    }
    if (character === ";" || character === "|" || character === "&") {
      if (character === "&" && command[index + 1] !== "&") {
        current += character;
        tokenStarted = true;
        continue;
      }
      if (!finishSegment()) return failure();
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

  if (quote) return failure();
  finishToken();
  if (tokens.length > 0) segments.push(tokens);
  // A trailing `;` or newline is valid shell, so classify what came before it
  // instead of failing — failing would make the NEW gate fail closed (fine)
  // but the signing-disable guard fail OPEN (regression).
  return {
    segments: segments.length > 0 ? segments : undefined,
    containsUnquotedExpansion,
  };
}

function tokenizeShell(command: string): string[][] | undefined {
  return tokenizeShellDetailed(command).segments;
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
  index: number; // index of the executable token (may be >= tokens.length)
  environment: Map<string, string>; // leading AND env-wrapper assignments
}

/**
 * Shared executable normalization for both git guards: skips leading
 * env-assignments and transparent wrappers (env, rtk, command, builtin, time,
 * nice, sudo), returning the executable token index and the collected
 * environment (leading assignments plus the env wrapper's own VAR=value
 * operands). The environment map is retained on GitInvocation for
 * diagnostics; round 8's --config-env handling reads the
 * configEnvironment list directly instead (the named variable's value is
 * treated as statically unknowable).
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
        if (["-u", "-g", "-h", "-p", "-C", "-T", "-U"].includes(tokens[index]))
          index++;
        index++;
      }
      moved = true;
    }
  }
  return { index, environment };
}

function parseGitInvocation(tokens: string[]): GitInvocation | undefined {
  const { index, environment } = resolveExecutable(tokens);
  if (tokens[index] !== "git" && !tokens[index]?.endsWith("/git"))
    return undefined;

  const args = tokens.slice(index + 1);
  const configValues: GitConfigValue[] = [];
  const configEnvironment: GitConfigEnvironment[] = [];

  for (let argIndex = 0; argIndex < args.length; argIndex++) {
    const token = args[argIndex];

    if (token === "-c") {
      const operand = args[argIndex + 1];
      const configValue = parseConfigValue(operand);
      if (configValue) {
        configValues.push(configValue);
      } else if (
        operand !== undefined &&
        CONFIG_UNKNOWABLE_RESIDUE_RE.test(operand)
      ) {
        // Round 8 (B6 judgment call): an operand WITHOUT a literal `=` but
        // WITH shell-structural residue may be a `$'…'` form whose escape
        // hid the `=` (e.g. $'commit.gpgsign\x3d0' → commit.gpgsign=0).
        // Record it raw so hasFalseySigningConfig fails closed on it. A
        // CLEAN bare key keeps its git meaning (no `=` → TRUE → not a
        // disable), unchanged.
        configValues.push({ key: operand, value: "" });
      }
      argIndex++;
      continue;
    }
    if (token.startsWith("-c") && token.length > 2) {
      const operand = token.slice(2);
      const configValue = parseConfigValue(operand);
      if (configValue) {
        configValues.push(configValue);
      } else if (CONFIG_UNKNOWABLE_RESIDUE_RE.test(operand)) {
        configValues.push({ key: operand, value: "" }); // same residue rule
      }
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
  /** True when the command must gate but no per-subcommand label applies: tokenization failed with a git mention, or round-8 B5 found an exotic executable / unquoted expansion. */
  unclassifiable: boolean;
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

/**
 * Creation options that take their operand as a separate token. `git tag`
 * only accepts these when creating a tag, so one seen in option position
 * (i.e. NOT consumed as another option's operand) is creation intent, and
 * the result is fail-closed WRITE even when the tag name is missing
 * (`git tag -m -l` — git consumes `-l` as the message and then errors
 * "no tag name?", so gating is harmless). Like every operand-taking
 * option, the separate-form operand is consumed WHATEVER it looks like
 * (git 2.55 parse-options takes the next token as the operand even when
 * it starts with `-` or is `--`): `git tag -m -v v1` creates `v1` with
 * message `-v`, so `-v` must not be mistaken for a verify flag. Attached
 * forms (`-mfoo`, `-ukey`, `-Fpath`, `--message=x`, `--trailer=x`) carry
 * the operand in the same token; the whitelist branches in
 * tagInvocationIsWrite recognize them and set creationSeen WITHOUT
 * consuming the next token.
 *
 * Round 5 added `--trailer` (OPT_STRVEC) and `--cleanup`: both take a
 * required separate operand and are creation-mode options — `git tag
 * --trailer -v -m msg v1` has `--trailer` consume `-v` and then CREATE
 * `v1` (probed against git 2.55: option parsing succeeds, the run dies
 * only on resolving HEAD), and combining `--trailer` with `-l` makes git
 * usage-error before doing anything. `--cleanup` likewise ALWAYS consumes
 * the next token as its operand: `git tag --cleanup -l v1` consumes `-l`
 * and then creates `v1` (probed: HEAD-resolve path). The reason bare `git
 * tag --cleanup -l` still exits 0 LISTING (probed against git 2.55) is
 * NOT that list mode tolerates `--cleanup` — it is that `-l` was eaten as
 * `--cleanup`'s operand, leaving no tag name, so git falls back to its
 * default list behavior. Our creation-set placement consumes `-l` the
 * same way and sets creationSeen, so such forms over-gate to WRITE —
 * fail-closed, the accepted cost (the command only ever lists or
 * usage-errors, never creates). The hidden `--with`/
 * `--without` are deliberately NOT here: they are commit-ish FILTERS
 * (deprecated aliases of `--contains`/`--no-contains`, probed: identical
 * "malformed object name <arg>" behavior) and live in
 * TAG_FILTER_DISPLAY_FLAGS_WITH_OPERAND.
 */
const TAG_CREATION_FLAGS_WITH_OPERAND = new Set([
  "-m",
  "--message",
  "-F",
  "--file",
  "-u",
  "--local-user",
  "--trailer",
  "--cleanup",
]);

/**
 * Filter and display modifier options that take their operand as a
 * separate token. These options do NOT settle the read/write question by
 * themselves — with no tag-name positional, git still lists (`git tag
 * --points-at HEAD` reads). The distinction when a positional IS present:
 * `--sort`/`--format` are display modifiers that do not imply list mode,
 * so the positional creates a tag (`git tag --sort refname created-tag`
 * creates; note an INVALID sort key like `name` or `--` makes git 2.55
 * error out before creating anything, so gating such forms is harmless).
 * The FILTER options (`--contains`, `--no-contains`, `--merged`,
 * `--no-merged`, `--points-at`) DO imply list mode and the positional is
 * a list pattern — but gating that form as a write is the accepted
 * fail-closed false positive. Their separate-form operands must not be
 * mistaken for tag names either way, and are consumed below whatever
 * they look like (same parse-options rule as the creation set above).
 * `--with`/`--without` are hidden options — deprecated aliases of
 * `--contains`/`--no-contains`' commit filter — that likewise take a
 * required commit-ish operand (probed against git 2.55: `git tag --with
 * -l` dies with "malformed object name -l", i.e. `-l` was consumed as
 * its operand), so their operands must be consumed here too, never
 * mistaken for tag names. Attached forms (`--sort=refname`,
 * `--points-at=HEAD`) are recognized by the stripped-name lookup in
 * tagInvocationIsWrite and need no next-token consumption. Together, the
 * two operand sets, TAG_KNOWN_NO_OPERAND_FLAGS, the strict-list forms,
 * and the fail-closed default in tagInvocationIsWrite cover the entire
 * option surface: every recognized option is attributed to its set, and
 * everything else — including unambiguous abbreviations of
 * operand-taking options (`--mess` for `--message`) — classifies WRITE.
 * `-n` is deliberately absent from the operand sets — its operand is
 * attached-only in git (`-n5`), and `git tag -n 5` is a list where `5`
 * is a pattern.
 */
const TAG_FILTER_DISPLAY_FLAGS_WITH_OPERAND = new Set([
  "--contains",
  "--no-contains",
  "--with",
  "--without",
  "--merged",
  "--no-merged",
  "--points-at",
  "--format",
  "--sort",
]);

/**
 * `git tag` options that take NO operand and are safe to skip when seen
 * in option position. This is a WHITELIST — the corresponding classifier
 * branch fails closed: any option-position token that is NOT in this
 * set, NOT in an operand set (separate or attached form), and NOT a
 * strict-list form classifies WRITE. That inversion is required because
 * git parse-options accepts UNAMBIGUOUS long-option abbreviations (`git
 * tag --mess -v v2` resolves `--mess` to `--message`, consumes `-v`, and
 * CREATES `v2` — probed against git 2.55), plus hidden and future
 * options, so no fixed list can recognize every read-only form. The
 * accepted cost: real reads spelled as unambiguous abbreviations of
 * whitelisted options (`--li` for `--list`), auto-generated negations
 * (`--no-column`), and unrecognized short bundles (`-al`) over-gate to
 * WRITE — safe, since git errors on genuinely unknown options (git
 * itself usage-errors on `-al`'s annotate/list mode conflict), so an
 * over-gate only ever demands a needless confirmation. Attached
 * `--color=always` / `--column=always` forms are recognized via the
 * stripped-name lookup in the classifier, so only the base names are
 * listed here. The strict-list forms and both operand sets are handled
 * by their own branches and are deliberately absent.
 */
const TAG_KNOWN_NO_OPERAND_FLAGS = new Set([
  "-a",
  "--annotate",
  "-s",
  "--sign",
  "--no-sign",
  "-e",
  "--edit",
  "-f",
  "--force",
  "--create-reflog",
  "--omit-empty",
  "-i",
  "--ignore-case",
  "--color",
  "--column",
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
 *
 * A single left-to-right, token-role-aware pass over the args after the
 * subcommand (mirrors git 2.55 builtin/tag.c parse-options behavior):
 *   1. `-d`/`--delete` anywhere → write (deletion wins over everything;
 *      kept as a global pre-scan — it over-gates bundled forms, which is
 *      fail-closed).
 *   2. After `--`, every token is a positional (tag name) → write.
 *   3. ANY operand-taking option — creation (`-m`, `--message`, `-F`,
 *      `--file`, `-u`, `--local-user`, `--trailer`, `--cleanup`) and
 *      filter/display (`--contains`, `--no-contains`, `--with`,
 *      `--without`, `--merged`, `--no-merged`, `--points-at`, `--format`,
 *      `--sort`) — consumes the next token WHATEVER it looks like:
 *      parse-options takes the operand even when it starts with `-` or is
 *      `--` (verified against git 2.55 — the bypasses this fixed: `git
 *      tag --format -l name` creates, because `-l` is `--format`'s
 *      operand; `git tag --sort -- v1` treats `--` as `--sort`'s operand
 *      and then dies on the invalid sort key, so gating it is harmless;
 *      `git tag -m -v v1` creates `v1` with message `-v`, because `-v` is
 *      `-m`'s operand; `git tag --trailer -v -m msg v1` creates `v1`
 *      because `--trailer` consumes `-v`). Creation options additionally
 *      set creationSeen: they are creation intent even with no tag name
 *      (`git tag -m -l` leaves no name after `-m` eats `-l`, git errors
 *      "no tag name?", and gating is fail-closed).
 *   4. Strict list/verify flag seen (not consumed as an operand) → read:
 *      these force list mode even when a tag name is present
 *      (`git tag -l 'v*'` reads; the trailing name is a pattern), and
 *      they win over creationSeen too (`git tag -m msg -l` lists; `git
 *      tag --trailer=x -l` is read the same way — harmless, because git
 *      2.55 usage-errors on trailer+list before doing anything).
 *   5. WHITELIST, fail-closed: any OTHER option-position token must be a
 *      recognized no-operand flag (TAG_KNOWN_NO_OPERAND_FLAGS) or an
 *      ATTACHED operand form — a long `--opt=value` is stripped at `=`
 *      and looked up in the operand sets (`--message=x` → creationSeen,
 *      `--trailer=x` likewise, `--format=%s` / `--sort=-x` → skip), and a
 *      short `-mfoo` / `-Fpath` / `-ukey` sets creationSeen without
 *      consuming the next token — else the invocation is WRITE. Rationale
 *      (round 4 finding B2): git parse-options accepts unambiguous
 *      long-option abbreviations, so `git tag --mess -v v2` resolves
 *      `--mess` to `--message`, consumes `-v`, and CREATES `v2` (probed
 *      against git 2.55); no fixed option list can recognize every
 *      read-only form, so everything unrecognized gates. Accepted false
 *      positives, all fail-closed WRITE on commands that either error or
 *      read: read abbreviations (`--li` for `--list`), auto-negations
 *      (`--no-column`), filter-option patterns (`--points-at HEAD
 *      'v*'`), and unrecognized short bundles (`-al`; git bundles `-a
 *      -l` but usage-errors on the mode conflict, and `-lm`-style mixes
 *      over-gate).
 *   6. Any tag-name positional → write (creation). Note the distinction
 *      among the "modifier" flags: `--sort`/`--format` are display modifiers
 *      that do NOT imply list mode, so a positional next to them really does
 *      create a tag (`git tag --sort refname created-tag` creates; an
 *      invalid sort key such as `name` or `--` makes git error out before
 *      creating anything, so gating it is harmless). The FILTER options
 *      (`--contains`, `--no-contains`, `--with`, `--without`, `--merged`,
 *      `--no-merged`, `--points-at`) DO imply list mode when no positional
 *      is given, and a positional alongside them is still a list PATTERN —
 *      but they are deliberately treated the same as display modifiers
 *      here: gating `git tag --points-at HEAD <pattern>` as a write is the
 *      known accepted false positive (fail-closed), and treating filters
 *      as list evidence was the original bypass bug.
 *   7. Otherwise → read: with no name positional, git lists (`git tag`,
 *      `git tag --sort=-creatordate`, `git tag --points-at HEAD`,
 *      `git tag --with HEAD`).
 */
function tagInvocationIsWrite(invocation: GitInvocation): boolean {
  const args = invocation.args.slice(invocation.subcommandIndex + 1);
  if (args.some((token) => token === "-d" || token === "--delete")) return true;
  const isStrictListFlag = (token: string): boolean =>
    token === "-l" ||
    token === "--list" ||
    token.startsWith("--list=") ||
    token === "-n" ||
    (token.startsWith("-n") && token.length > 2) ||
    token === "-v" ||
    token === "--verify";
  let afterDoubleDash = false;
  let strictListSeen = false;
  let creationSeen = false;
  let positionalSeen = false;
  for (let index = 0; index < args.length; index++) {
    const token = args[index];
    if (afterDoubleDash) {
      positionalSeen = true; // everything after `--` is a tag-name positional
      continue;
    }
    if (token === "--") {
      afterDoubleDash = true;
      continue;
    }
    if (TAG_CREATION_FLAGS_WITH_OPERAND.has(token)) {
      index++; // consume separate-form operand — even if it starts with '-' or is '--'
      creationSeen = true; // creation-only options: write intent even without a tag name
      continue;
    }
    if (TAG_FILTER_DISPLAY_FLAGS_WITH_OPERAND.has(token)) {
      index++; // consume separate-form operand — even if it starts with '-' or is '--'
      continue;
    }
    if (isStrictListFlag(token)) {
      strictListSeen = true; // `-l`/`-n`/`-v` force list mode; positionals are patterns
      continue;
    }
    if (token.startsWith("--")) {
      // Long option not matched by any set yet: strip an attached `=value`
      // and attribute the option to its set. No next-token consumption —
      // the operand rides in the same token.
      const name = token.split("=")[0]!;
      if (TAG_KNOWN_NO_OPERAND_FLAGS.has(name)) continue; // `--color=always`
      if (TAG_CREATION_FLAGS_WITH_OPERAND.has(name)) {
        creationSeen = true; // attached creation operand: `--message=x`, `--trailer=x`
        continue;
      }
      if (TAG_FILTER_DISPLAY_FLAGS_WITH_OPERAND.has(name)) continue; // `--format=%s`, `--sort=-x`
      // Unrecognized long option — unambiguous abbreviation (`--mess`),
      // hidden option, or future option — fails closed to WRITE.
      return true;
    }
    if (token.length > 1 && token.startsWith("-")) {
      // Single-dash short token.
      if (TAG_KNOWN_NO_OPERAND_FLAGS.has(token)) continue; // `-a`, `-s`, `-e`, `-f`, `-i`
      if (token.length === 2) {
        return true; // unrecognized exact short flag (`-x`); known shorts matched above
      }
      if (
        token.startsWith("-m") ||
        token.startsWith("-F") ||
        token.startsWith("-u")
      ) {
        creationSeen = true; // attached operand: `-mfoo`, `-Fpath`, `-ukey`
        continue;
      }
      return true; // unrecognized short bundle (`-al`, `-lm`) fails closed
    }
    positionalSeen = true; // tag-name positional: `git tag v1`, `git tag -a v1 -m x` create
  }
  if (strictListSeen) return false;
  if (creationSeen || positionalSeen) return true;
  return false; // bare `git tag`, or filter/display modifiers only → list
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
  return invocation.args.slice(invocation.subcommandIndex + 1).includes("-w");
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
  for (let flagIndex = index + 1; flagIndex + 1 < segment.length; flagIndex++) {
    const token = segment[flagIndex];
    if (token === "-c" || /^-[a-z]*c[a-z]*$/.test(token)) {
      if (/\bgit\b/.test(segment[flagIndex + 1])) return true;
    }
  }
  return false;
}

/**
 * Round 8 (B5.1): characters that make a RESOLVED EXECUTABLE token
 * unclassifiable — shell expansion/glob/tilde/brace characters (`$`, ``
 * ``, `*`, `?`, `~`, `{`, `}`), quote/paren residue from quoted words, or
 * backslash escape residue (`gi\\t`). Any of these means the executable
 * the shell will actually run is not statically knowable (`$'git'`,
 * `g?t`, `~/bin/git`, `g{,}it` all resolve to git at runtime), so the
 * whole command is treated as unclassifiable and write-gated. Executable
 * names in legitimate commands never contain these characters; the only
 * cost is gating pathological commands that were gated or broken anyway.
 * (Unquoted `$(…)`, backticks, and parens never reach this check — the
 * tokenizer already refuses them.)
 */
const EXOTIC_EXECUTABLE_RE = /[$`*?~{}()"'\\]/;

/**
 * Round 8 (B5): an unparseable command whose EXECUTABLE position is itself
 * an expansion — any `;`/`|`/`&`/newline-separated piece of the de-escaped
 * raw string starting with `$` or a backtick (`$(printf g%s it) tag v1`).
 * The resolved executable is unknowable, so the command is unclassifiable
 * and gated unconditionally (no git-mention requirement: `$(printf g%s it)
 * tag v1` carries no literal git word). `echo $(date)` is untouched — its
 * expansion is in ARGUMENT position. Accepted over-gate: a bare `$(…)` or
 * backtick command (e.g. `$(date)`) also gates; such commands are
 * pathological in agent hands.
 */
function hasExpansionExecutable(deEscaped: string): boolean {
  return deEscaped
    .split(/[\n;|&]+/)
    .some((piece) => /^[$`]/.test(piece.trim()));
}

/**
 * Round 8 (B5) — accepted residuals, deliberately NOT handled (documented
 * per the round-8 brief; this is the final hardening round):
 *   - Glob characters in ARGUMENT position: `git diff -- *.ts` can match a
 *     maliciously named local file and change the diff, but cannot turn a
 *     read subcommand into a history/remote mutation; requires attacker-
 *     controlled filenames on disk.
 *   - Tilde/brace expansion in ARGUMENT position (same reasoning).
 *   - Shell aliases, shell functions, `eval`, scripts, `xargs git`,
 *     `nohup git`, and other wrappers that invoke git internally.
 *   - Cross-command environment tricks via files or a prior bash
 *     invocation (e.g. GIT_CONFIG_* exported by an earlier command): only
 *     the same command string is scanned.
 *   - Backslash escapes inside $'…' that rebuild disable text WITHOUT a
 *     prefix-anchored or residue-tripped signal (e.g.
 *     $'--no-gpg-\x73ign' IS caught — the disable regexes are prefix-
 *     anchored — but a fully opaque $'$(…)'-free construct carrying no
 *     gpgsign literal and no residue is not).
 *   - Expansion-built config/executable text with neither a gpgsign
 *     literal nor shell-structural residue (e.g. -c "$(printf
 *     'commit.gpg%s=false' sign)" — no literal "gpgsign", no residue in
 *     the recorded key).
 *   - Leading env assignments before an expansion executable
 *     (`FOO=1 $(printf g%s it) tag v1`) — no expansion-at-segment-start,
 *     no git mention; the executable is still unknowable.
 */
function classifyGitWrite(command: string): GitWriteClassification {
  const deEscaped = deEscapeShell(command);
  const { segments, containsUnquotedExpansion } =
    tokenizeShellDetailed(command);
  if (!segments) {
    // B3 residual (round 7): exotic (non-IFS) whitespace — Unicode
    // whitespace or a bare CR — makes token boundaries here diverge from
    // the shell's, AND escaped-executable forms (`g\it`) evade a raw
    // /\bgit\b/ mention test. Exotic whitespace in a shell command is
    // pathological and never legit, so block UNCONDITIONALLY — no
    // git-mention requirement. Accepted over-gate: `echo a<NBSP>b` and
    // `echo a<CR>b` also gate (approvably, via the question tool).
    if (containsExoticWhitespace(command)) {
      return {
        hasGit: /\bgit\b/.test(deEscaped),
        isWrite: true,
        writeSubcommands: ["<exotic whitespace>"],
        unclassifiable: true,
      };
    }
    // Round 8 (B5): the mention test runs on the DE-ESCAPED raw string so
    // `<(g\it tag v1)`-style escaped executables cannot evade it (the
    // shell resolves `g\it` to git; the tokenizer refused the command at
    // the paren, so this raw check is the only line of defense).
    const mentionsGit = /\bgit\b/.test(deEscaped);
    if (mentionsGit) {
      // Fail closed: any other unparseable command mentioning git is gated.
      return {
        hasGit: true,
        isWrite: true,
        writeSubcommands: ["<unparseable>"],
        unclassifiable: true,
      };
    }
    // Round 8 (B5): an expansion-resolved executable with no literal git
    // mention (`$(printf g%s it) tag v1`) is equally unclassifiable — the
    // executable could resolve to git — so it gates unconditionally.
    if (hasExpansionExecutable(deEscaped)) {
      return {
        hasGit: false,
        isWrite: true,
        writeSubcommands: ["<unclassifiable executable>"],
        unclassifiable: true,
      };
    }
    return {
      hasGit: false,
      isWrite: false,
      writeSubcommands: [],
      unclassifiable: false,
    };
  }

  const writeSubcommands: string[] = [];
  const invocations: GitInvocation[] = [];
  let hasExoticExecutable = false;
  for (const segment of segments) {
    // B5.1: an executable token spelled with expansion/glob/tilde/brace/
    // residue characters is unclassifiable — skip classification entirely.
    const { index } = resolveExecutable(segment);
    const executable = segment[index];
    if (executable !== undefined && EXOTIC_EXECUTABLE_RE.test(executable)) {
      hasExoticExecutable = true;
      continue;
    }
    if (shellLauncherMentionsGit(segment)) {
      writeSubcommands.push("<sh -c>");
      continue;
    }
    // parseGitInvocation distinguishes "no git" from "unparseable"; it
    // re-runs resolveExecutable internally — a harmless duplicate pure
    // computation, one normalization path either way.
    const invocation = parseGitInvocation(segment);
    if (!invocation) continue;
    invocations.push(invocation);
    if (gitInvocationIsWrite(invocation)) {
      writeSubcommands.push(invocation.subcommand ?? "<git>");
    }
  }
  if (hasExoticExecutable) {
    return {
      hasGit: true,
      isWrite: true,
      writeSubcommands: ["<unclassifiable executable>"],
      unclassifiable: true,
    };
  }
  // B5.2: an unquoted expansion ($VAR, ${…}, $@/special params) anywhere in
  // a git-mentioning command (mention tested on the de-escaped raw string —
  // `git${IFS}tag` must count) makes the shell's word structure statically
  // unknowable → unclassifiable. QUOTED expansions do NOT trigger this:
  // they produce exactly one word and the classifier already treats unknown
  // words as positionals — the fail-closed direction — so
  // `git commit -m "$(date)"` stays a classified commit write.
  if (
    containsUnquotedExpansion &&
    (invocations.length > 0 ||
      writeSubcommands.length > 0 ||
      /\bgit\b/.test(deEscaped))
  ) {
    return {
      hasGit: true,
      isWrite: true,
      writeSubcommands: ["<shell expansion>"],
      unclassifiable: true,
    };
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
      `This command could not be parsed safely. Conservatively blocked forms include: unparseable commands mentioning git; commands containing exotic (non-IFS) whitespace (Unicode whitespace such as NBSP, or a bare carriage return); commands whose EXECUTABLE is spelled with shell expansion/glob characters ($, backtick, *, ?, ~, braces, or quote/backslash residue — e.g. g?t, ~/bin/git, $(…)); and unquoted shell expansions ($VAR, \${…}, command/process substitution) in a git-mentioning command — the shell's word structure is statically unknowable in all of these, so no token-based classification can match what will actually run. Rewrite it in a simpler form (a single plain command, plain executable name, no command substitution, subshells, or unquoted variables — quote any argument that needs $ or glob characters) and try again.`,
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

/**
 * Git 2.55 boolean parsing: `false`, `0`, `no`, `off` (any case) AND empty
 * (`-c commit.gpgsign=` / `git config commit.gpgsign ''`) all mean
 * disabled. A bare `-c commit.gpgsign` (no `=`) is not a falsey value —
 * it means TRUE — and is handled structurally: parseConfigValue rejects
 * keys without `=`, so no configValue is ever recorded for that form.
 */
function isFalseyGitConfigValue(value: string | undefined): boolean {
  return (
    value !== undefined &&
    (value === "" || ["false", "off", "no", "0"].includes(value.toLowerCase()))
  );
}

/**
 * Any `*.gpgsign` config key (or a bare `gpgsign`, which git rejects as a
 * key without a section anyway — harmless to match). Keys arrive already
 * lowercased from parseConfigValue/parseConfigEnvironment, covering git's
 * case-insensitive key matching (`commit.GPGSign` ≡ `commit.gpgsign`).
 * Matching ANY section's gpgsign key (not just commit.gpgsign/tag.gpgsign)
 * is deliberate fail-closed: a signing-capable command carrying some other
 * section's gpgsign key with a falsey value is pathological, and the
 * residual false positive (e.g. `-c tag.gpgsign=false commit`, which does
 * not actually disable commit signing) only over-blocks a command nobody
 * legitimately writes.
 */
function isGpgsignConfigKey(key: string): boolean {
  return key === "gpgsign" || key.endsWith(".gpgsign");
}

/** git's `GIT_CONFIG_KEY_<i>=<key>` environment-assignment form (exact case — env names are case-sensitive). */
const GIT_CONFIG_ENV_KEY_RE = /^GIT_CONFIG_KEY_(\d+)=(.*)$/;
/** git's `GIT_CONFIG_VALUE_<i>=<value>` environment-assignment form. */
const GIT_CONFIG_ENV_VALUE_RE = /^GIT_CONFIG_VALUE_(\d+)=(.*)$/;

/**
 * Round 8 (B6.1), round 9 masking fix: scan for git's GIT_CONFIG_*
 * environment config channel (git ≥ 2.31). `GIT_CONFIG_COUNT=1
 * GIT_CONFIG_KEY_0=commit.gpgsign GIT_CONFIG_VALUE_0=false git commit`
 * resolves commit.gpgsign=false and produces an UNSIGNED commit, and the
 * assignments may appear anywhere — leading tokens (resolveExecutable skips
 * them), `env` operands, or `export VAR=…;` statements in earlier segments
 * (the exported environment persists across `;`-chained segments).
 * GIT_CONFIG_COUNT is deliberately ignored: requiring it would open a bypass
 * via a mis-parsed count, while ignoring it only over-blocks.
 *
 * Scope (round 9, pinned): a signing-capable invocation in segment k is
 * evaluated against the GIT_CONFIG_* tokens of segments 0..k ONLY. Earlier
 * segments are all treated as in effect (fail-closed approximation of export
 * persistence — an `echo GIT_CONFIG_VALUE_0=false` argument in an earlier
 * segment also counts, over-blocking in the safe direction). Segments AFTER
 * k are invisible to the invocation: they execute later and cannot change its
 * environment, so a trailing `echo GIT_CONFIG_VALUE_0=true` can neither mask
 * a real disable nor fabricate one.
 *
 * Accumulation (round 9 masking fix — the old index-keyed Map let a LATER
 * token overwrite an EARLIER same-index assignment, so `…VALUE_0=false git
 * commit; echo VALUE_0=true` ran the commit with gpgsign=false while the
 * echo argument masked the disable): every assignment token in scope is
 * evaluated independently and a disable, once earned, is never cleared.
 *   - ANY KEY_<i> token carrying shell-structural residue → disable
 *     (unknowable key; checked per token, not last-wins)
 *   - once ANY KEY_<i> token names a gpgsign key, index i stays gpgsign —
 *     a later `KEY_<i>=user.name` never clears it (masking may only weaken)
 *   - for a gpgsign index i: NO VALUE_<i> token in scope → disable
 *     (fail-closed; the value may come from the caller's real environment)
 *   - for a gpgsign index i: ANY VALUE_<i> token with residue → disable;
 *     ANY falsey VALUE_<i> token → disable — a later "true" NEVER clears an
 *     earlier "false"
 *
 * Decision table for a KEY_<i> whose key is (or could be) gpgsign:
 *   - key carries shell-structural residue       → disable (unknowable key)
 *   - key is gpgsign + VALUE_<i> missing         → disable (fail-closed;
 *     the value may come from the caller's real environment — statically
 *     unknowable, and a gpgsign KEY without a VALUE has ~zero legit use)
 *   - key is gpgsign + VALUE carries residue     → disable (unknowable value)
 *   - key is gpgsign + VALUE falsey              → disable
 *   - key is gpgsign + every VALUE token in scope is clean and truey
 *                                               → not a disable (normal
 *     write gate applies)
 *   - key is not gpgsign and carries no residue  → not a disable
 *
 * Accepted fail-closed over-blocks (round 9, deliberate):
 *   - `…VALUE_0=false git commit; …VALUE_0=true git commit` — the second
 *     commit would run signed (leading assignments do not persist across
 *     `;`), but the first invocation's disable blocks the whole command.
 *   - `export KEY_0=commit.gpgsign; export KEY_0=user.name; git commit` —
 *     the final exported key is user.name, yet the latched gpgsign index
 *     with a missing VALUE still disables.
 */
function gitConfigEnvDisablesSigning(
  segments: string[][],
  lastSegmentIndex: number,
): boolean {
  const gpgsignIndices = new Set<string>();
  const values = new Map<string, string[]>();
  for (let segmentIndex = 0; segmentIndex <= lastSegmentIndex; segmentIndex++) {
    for (const token of segments[segmentIndex]) {
      const keyAssignment = GIT_CONFIG_ENV_KEY_RE.exec(token);
      if (keyAssignment) {
        if (CONFIG_UNKNOWABLE_RESIDUE_RE.test(keyAssignment[2])) return true;
        if (isGpgsignConfigKey(keyAssignment[2].toLowerCase())) {
          gpgsignIndices.add(keyAssignment[1]);
        }
      }
      const valueAssignment = GIT_CONFIG_ENV_VALUE_RE.exec(token);
      if (valueAssignment) {
        const indexValues = values.get(valueAssignment[1]);
        if (indexValues === undefined) {
          values.set(valueAssignment[1], [valueAssignment[2]]);
        } else {
          indexValues.push(valueAssignment[2]);
        }
      }
    }
  }
  for (const index of gpgsignIndices) {
    const indexValues = values.get(index);
    if (indexValues === undefined) return true;
    for (const value of indexValues) {
      if (CONFIG_UNKNOWABLE_RESIDUE_RE.test(value)) return true;
      if (isFalseyGitConfigValue(value)) return true;
    }
  }
  return false;
}

function hasFalseySigningConfig(invocation: GitInvocation): boolean {
  return (
    invocation.configValues.some(
      (config) =>
        (isGpgsignConfigKey(config.key) &&
          (isFalseyGitConfigValue(config.value) ||
            // Quoted-expansion / escape residue under a gpgsign key: the
            // runtime value is unknowable (e.g. -c "$(echo
            // commit.gpgsign=false)" → key "$(echo commit.gpgsign", value
            // "false)") → fail closed.
            CONFIG_UNKNOWABLE_RESIDUE_RE.test(config.value))) ||
        // A key carrying residue could BE a gpgsign key in disguise
        // (`commit.$(echo gpgsign)`) — block when it mentions gpgsign.
        (CONFIG_UNKNOWABLE_RESIDUE_RE.test(config.key) &&
          /gpgsign/i.test(config.key)),
    ) ||
    // Round 8 (B6.2): --config-env feeds the key's value from a NAMED
    // environment variable. When that variable is not assigned inside the
    // command itself, the value is statically unknowable — and even when a
    // leading assignment makes it look truey, pathological construction
    // outweighs legitimate use. ANY gpgsign key via --config-env (attached
    // `--config-env=commit.gpgsign=V` or separate `--config-env
    // commit.gpgsign=V` form) is therefore blocked unconditionally.
    invocation.configEnvironment.some((config) =>
      isGpgsignConfigKey(config.key),
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
  if (key === undefined || !isGpgsignConfigKey(key)) return false;
  if (isUnset || usesModernUnset) return true;
  return isFalseyGitConfigValue(positional[usesModernSet ? 2 : 1]);
}

/**
 * Long-option signing-disable signals (git 2.55, reviewer-verified facts):
 * - Long-option names are CASE-SENSITIVE (`--No-GPG-Sign` is an unknown
 *   option; git errors on it, so not flagging it is fine).
 * - parse-options accepts unambiguous abbreviations: `--no-g`, `--no-gp`,
 *   … all resolve to `--no-gpg-sign`, and NO other commit/tag option
 *   starts `--no-g`, so the prefix `/^--no-g/` covers every unambiguous
 *   abbreviation without over-matching.
 * - `--no-sign` prefixes: only the EXACT forms `--no-s`, `--no-si`,
 *   `--no-sig`, `--no-sign` count — `--no-signoff`/`--no-signo`… and
 *   `--no-status`/other `--no-*` options must NOT match (they are legit,
 *   approvable commands, and this guard is unconditional).
 */
const GPG_SIGN_DISABLE_OPTION_RE = /^--no-g/;
const TAG_SIGN_DISABLE_OPTION_RE = /^--no-s(i(g(n)?)?)?$/;

/** True when any argument token is a --no-gpg-sign/--no-sign disable form. */
// Both regexes are checked against every signing-capable subcommand,
// not scoped per-branch: the cross-branch forms (`git commit --no-s…`,
// `git tag --no-g…`) are unknown or ambiguous options that git errors on
// anyway, so flagging them is fail-closed with no false cost, and it
// keeps git-accepted disable forms from slipping through on subcommand
// drift.
function argsDisableSigning(args: string[]): boolean {
  return args.some(
    (arg) =>
      GPG_SIGN_DISABLE_OPTION_RE.test(arg) ||
      TAG_SIGN_DISABLE_OPTION_RE.test(arg),
  );
}

/**
 * Raw-signal fail-closed check for commands tokenizeShell refuses (exotic
 * whitespace, unquoted `$(…)`, backticks, parens, unbalanced quotes). The
 * parsed path cannot run for these, so without this check the guard would
 * fail OPEN. Approximations are safe here: any command reaching this branch
 * is gated by the write gate regardless, so a boundary mistake can only
 * hard-block a command that was gated anyway (or over-block a pathological
 * unparseable command that mentions both git and gpgsign, e.g.
 * `git log --grep=gpgsign$(date)`).
 */
function rawSignalsSigningDisable(deEscaped: string): boolean {
  if (!/\bgit\b/.test(deEscaped)) return false;
  // Any signing disable the shell can actually execute must carry the
  // signal inside a gpgsign key (covers GIT_CONFIG_KEY_0=commit.gpgsign
  // triplets too) or as a whole option token.
  if (/gpgsign/i.test(deEscaped)) return true;
  return deEscaped
    .split(/\s+/)
    .some(
      (token) =>
        GPG_SIGN_DISABLE_OPTION_RE.test(token) ||
        TAG_SIGN_DISABLE_OPTION_RE.test(token),
    );
}

function detectSigningDisable(command: string): boolean {
  const deEscaped = deEscapeShell(command);
  if (containsExoticWhitespace(command)) {
    // B3 fail-closed: tokenizeShell refuses this command, so the parsed
    // path below would silently fail OPEN. Fail closed on a raw-signal
    // basis instead.
    //
    // Defense-in-depth (round 7): the git-write gate also blocks every
    // exotic-whitespace command unconditionally, but that gate is
    // APPROVABLE (question tool) while this guard is not — without this
    // branch, a user confirmation would let `g\it -c commit.gpgsign=0
    // commit …<NBSP>…` run and disable signing. Backslash de-escaping
    // first: outside quotes the shell treats `\x` as `x`, so `g\it` RUNS
    // as git while evading a raw /\bgit\b/ test (and `commit.gpg\sign=0`
    // reaches git as a real gpgsign key).
    return rawSignalsSigningDisable(deEscaped);
  }
  const segments = tokenizeShell(command);
  if (!segments) {
    // Round 8 extension of the same logic: ANY unparseable command (not
    // just exotic whitespace) would leave the parsed path below with zero
    // invocations and fail OPEN — e.g. `git$(x) -c commit.gpgsign=0
    // commit` never reaches hasFalseySigningConfig without this branch.
    return rawSignalsSigningDisable(deEscaped);
  }
  // Round 8 (B6.1) / round 9: GIT_CONFIG_KEY_i/GIT_CONFIG_VALUE_i
  // assignments can sit in ANY segment up to and including the invocation's
  // own (export statements, env wrappers, leading tokens; earlier segments
  // are conservatively treated as persisting). The env-config scan is
  // therefore computed PER INVOCATION with scope segments[0..k] — a token in
  // a later segment executes after the invocation and can neither mask a
  // disable (round 9 fix) nor trigger one — and OR'd into every
  // signing-capable branch below.
  for (let segmentIndex = 0; segmentIndex < segments.length; segmentIndex++) {
    const invocation = parseGitInvocation(segments[segmentIndex]);
    if (!invocation) continue;
    const subcommand = invocation.subcommand;
    if (!subcommand) continue;
    const envConfigDisables = gitConfigEnvDisablesSigning(
      segments,
      segmentIndex,
    );

    if (
      GIT_COMMIT_SIGNING_SUBCOMMANDS.has(subcommand) &&
      (argsDisableSigning(invocation.args) ||
        hasFalseySigningConfig(invocation) ||
        envConfigDisables)
    ) {
      return true;
    }
    if (
      subcommand === "tag" &&
      isSigningCapableGitInvocation(invocation) &&
      (argsDisableSigning(invocation.args) ||
        hasFalseySigningConfig(invocation) ||
        envConfigDisables)
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
const USE_DISPATCH_REMINDERS = false;
const PRIMARY_AGENT_TURN_REMINDER_MARKER = "<primary-agent-turn-reminder>";

const DISPATCH_REMINDERS: Record<string, string> = {
  build: `<system-reminder>
${PRIMARY_AGENT_TURN_REMINDER_MARKER}
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
      if (USE_DISPATCH_REMINDERS) {
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
