---@return string
local function get_current_python_path()
  local python_paths = {}

  for path in string.gmatch(vim.fn.system("where python"), "[^\r\n]+") do
    table.insert(python_paths, path)
  end

  local current_path = python_paths[1]
  vim.lsp.log.error("[basedpyright] current_python_path = " .. current_path)

  return current_path
end

---@type vim.lsp.Config
return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "requirements.txt",
    ".venv",
  },
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",
        useLibraryCodeForTypes = true,
        -- inlayHints = {
        --   callArgumentNames = false,
        --   functionReturnTypes = false,
        --   genericTypes = false,
        --   variableTypes = false,
        -- },
      },
    },
    python = {
      pythonPath = get_current_python_path(),
    },
  },
}
