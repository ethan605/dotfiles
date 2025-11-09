---@type vim.lsp.Config
return {
  cmd = { "pyrefly", "lsp" },
  filetypes = { "python" },
  root_markers = {
    "pyrefly.toml",
    "pyproject.toml",
    ".venv",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
  },
  ---@diagnostic disable-next-line: unused-local
  on_attach = function(client, bufnr)
    -- Use renameProvider from pyright instead
    client.server_capabilities.renameProvider = nil
  end,
}
