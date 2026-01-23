# Code Navigation - LSP First

ALWAYS prefer LSP tools over Grep/Glob for symbol-based code navigation.

## LSP Operations Reference

| Task | LSP Operation | Instead of |
|------|---------------|------------|
| Find where symbol is defined | `goToDefinition` | `grep "class Foo"` or `grep "def bar"` |
| Find all usages of a symbol | `findReferences` | `grep "symbol_name"` |
| Get type info / documentation | `hover` | Reading source manually |
| List symbols in a file | `documentSymbol` | `grep "def\|class"` |
| Find interface implementations | `goToImplementation` | `grep "implements"` |
| Prepare call hierarchy at position | `prepareCallHierarchy` | Manual tracing |
| Find callers of a function | `incomingCalls` | `grep "function_name("` |
| Find callees from a function | `outgoingCalls` | Reading function body |
| Search symbols across workspace | `workspaceSymbol` | `grep` across files |

## Use Grep/Glob ONLY when:
- Searching for **string literals** or **comments**
- Searching for **regex patterns** that aren't symbol names
- LSP returns no results or errors
- Searching for **file patterns** (use Glob, e.g., `**/*.py`)
- Searching **non-code content** (configs, logs, YAML, JSON, etc.)

## Examples

```
# BAD - Don't use grep for symbol navigation
grep -r "class EncordException" .
grep -r "def authenticate" .

# GOOD - Use LSP instead
LSP goToDefinition on EncordException
LSP findReferences on authenticate()
LSP incomingCalls to find what calls a function
```

## Language-Specific Notes

### Python (Pyright)
- ✅ `goToDefinition`, `findReferences`, `hover`, `documentSymbol` - work well
- ✅ `incomingCalls`, `outgoingCalls`, `prepareCallHierarchy` - work well
- ⚠️ `workspaceSymbol` - **does not work reliably with Pyright**; fall back to Grep for workspace-wide symbol search in Python
- ⚠️ `goToImplementation` - only useful for abstract classes/protocols

### TypeScript (tsserver)
- ✅ All operations work well, including `workspaceSymbol`
- ✅ `goToImplementation` - works for interfaces and abstract classes

### General
- LSP requires the language server to be running and properly configured
- If LSP returns empty results unexpectedly, verify the file is within the project workspace

# Notion Preferences

When creating or editing Notion pages:
- Use callouts (`<callout>`) instead of blockquotes (`>`) for highlighted content. Choose appropriate icons and colors:
  - ⚠️ `yellow_bg` for warnings/important notes
  - 👋 `blue_bg` for manual steps or action items
  - 📎 `gray_bg` for references
  - 💡 `gray_bg` for tips
- Place Table of Contents (`<table_of_contents/>`) at the very top of the document
