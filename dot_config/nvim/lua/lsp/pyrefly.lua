---@type vim.lsp.Config
return {
  cmd = { "pyrefly", "lsp" },
  filetypes = { "python" },
  root_markers = {
    "pyrefly.toml",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
  },
}

--[[
server_capabilities:

{
  codeActionProvider = {
    codeActionKinds = { "quickfix" }
  },
  completionProvider = {
    triggerCharacters = { "." }
  },
  definitionProvider = true,
  documentHighlightProvider = true,
  documentSymbolProvider = true,
  foldingRangeProvider = true,
  hoverProvider = true,
  inlayHintProvider = true,
  positionEncoding = "utf-16",
  referencesProvider = true,
  renameProvider = {
    prepareProvider = true
  },
  semanticTokensProvider = {
    full = true,
    legend = {
      tokenModifiers = { "declaration", "definition", "readonly", "static", "deprecated", "abstract", "async", "modification", "documentation", "defaultLibrary" },
      tokenTypes = { "namespace", "type", "class", "enum", "interface", "struct", "typeParameter", "parameter", "variable", "property", "enumMember", "event", "function", "method", "macro", "keyword", "modifier", "comment", "string"
, "number", "regexp", "operator", "decorator" }
    },
    range = true
  },
  signatureHelpProvider = {
    triggerCharacters = { "(", "," }
  },
  textDocumentSync = {
    change = 2,
    openClose = true,
    save = {
      includeText = false
    },
    willSave = false,
    willSaveWaitUntil = false
  },
  typeDefinitionProvider = true,
  workspace = {
    fileOperations = {
      willRename = {
        filters = { {
            pattern = {
              glob = "**/*.{py,pyi}",
              matches = "file"
            },
            scheme = "file"
          } }
      }
    },
    workspaceFolders = {
      changeNotifications = true,
      supported = true
    }
  },
  workspaceSymbolProvider = true
}
]]
