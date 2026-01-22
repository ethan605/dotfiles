# Code Navigation

When navigating code (finding definitions, references, understanding types), prefer using the LSP tool over Grep/Glob:
- `goToDefinition` - Find where a symbol is defined
- `findReferences` - Find all usages of a symbol
- `hover` - Get type information and documentation
- `documentSymbol` - List all symbols in a file

Only fall back to Grep for text pattern searches that aren't symbol-based (e.g., searching for string literals, comments, or regex patterns).

# Notion Preferences

When creating or editing Notion pages:
- Use callouts (`<callout>`) instead of blockquotes (`>`) for highlighted content. Choose appropriate icons and colors:
  - ⚠️ `yellow_bg` for warnings/important notes
  - 👋 `blue_bg` for manual steps or action items
  - 📎 `gray_bg` for references
  - 💡 `gray_bg` for tips
- Place Table of Contents (`<table_of_contents/>`) at the very top of the document
