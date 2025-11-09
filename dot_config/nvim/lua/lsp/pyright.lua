---@type vim.lsp.Config
return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    ".venv",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
  },
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
  },
  ---@diagnostic disable-next-line: unused-local
  on_attach = function(client, bufnr)
    -- Disable capabilities that conflict with pyrefly
    client.server_capabilities.codeActionProvider = nil
    client.server_capabilities.completionProvider = nil
    client.server_capabilities.declarationProvider = nil
    client.server_capabilities.definitionProvider = nil
    client.server_capabilities.documentHighlightProvider = nil
    client.server_capabilities.documentSymbolProvider = nil
    client.server_capabilities.executeCommandProvider = nil
    client.server_capabilities.hoverProvider = nil
    client.server_capabilities.referencesProvider = nil
    client.server_capabilities.typeDefinitionProvider = nil
    client.server_capabilities.workspace = nil
    client.server_capabilities.workspaceSymbolProvider = nil
  end,
}
