# Code Navigation

When navigating code (finding definitions, references, understanding types), prefer using the LSP tool over Grep/Glob:
- `goToDefinition` - Find where a symbol is defined
- `findReferences` - Find all usages of a symbol
- `hover` - Get type information and documentation
- `documentSymbol` - List all symbols in a file

Only fall back to Grep for text pattern searches that aren't symbol-based (e.g., searching for string literals, comments, or regex patterns).
