---@type vim.lsp.Config
return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "requirements.txt",
    ".venv",
  },
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
  },
}

--[[
--server_capabilities:

{
  callHierarchyProvider = true,
  codeActionProvider = {
    codeActionKinds = { "quickfix", "source.organizeImports" },
    workDoneProgress = true
  },
  completionProvider = {
    completionItem = {
      labelDetailsSupport = true
    },
    resolveProvider = true,
    triggerCharacters = { ".", "[", '"', "'" },
    workDoneProgress = true
  },
  declarationProvider = {
    workDoneProgress = true
  },
  definitionProvider = {
    workDoneProgress = true
  },
  documentHighlightProvider = {
    workDoneProgress = true
  },
  documentSymbolProvider = {
    workDoneProgress = true
  },
  executeCommandProvider = {
    commands = {},
    workDoneProgress = true
  },
  hoverProvider = {
    workDoneProgress = true
  },
  referencesProvider = {
    workDoneProgress = true
  },
  renameProvider = {
    prepareProvider = true,
    workDoneProgress = true
  },
  signatureHelpProvider = {
    triggerCharacters = { "(", ",", ")" },
    workDoneProgress = true
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
  typeDefinitionProvider = {
    workDoneProgress = true
  },
  workspace = {
    workspaceFolders = {
      changeNotifications = true,
      supported = true
    }
  },
  workspaceSymbolProvider = {
    workDoneProgress = true
  }
}
--]]
