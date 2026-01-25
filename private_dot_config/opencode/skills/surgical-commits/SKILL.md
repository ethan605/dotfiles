# Surgical Commits Skill

## Triggers
- After completing any task from a plan
- After any code change that passes tests

## Behavior

### Commit Timing
- **One task = one commit**. Never combine multiple tasks in a single commit.
- Commit immediately after task completion, before moving to the next task.
- If a task requires multiple logical changes, prefer multiple smaller commits.

### Commit Message Format
```
<type>(<phase>-<task>): <description>

[optional body explaining what and why]
```

Where:
- `type`: feat|fix|docs|test|refactor|chore
- `phase`: Two-digit phase number from plan (e.g., 01, 02)
- `task`: Two-digit task number within phase (e.g., 01, 02, 03)
- `description`: Imperative mood, lowercase, no period, max 50 chars

### Examples
```
feat(02-01): add user registration endpoint
test(02-01): add integration tests for registration
fix(02-02): handle duplicate email gracefully
docs(02-03): document registration API in OpenAPI spec
```

### Verification Before Commit
1. Tests pass
2. Only files related to this specific task are staged
3. No unrelated changes included
4. Commit message follows format

### Why This Matters
- `git bisect` finds exact failing task
- Each task independently revertable  
- Clear history for future Claude sessions
- Better observability in AI-automated workflows
- Every commit is surgical, traceable, and meaningful