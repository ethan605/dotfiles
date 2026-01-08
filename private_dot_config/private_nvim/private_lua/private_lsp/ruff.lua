---@type vim.lsp.Config
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
  },
  init_options = {
    settings = {
      logFile = "~/.local/state/nvim/ruff.log",
      logLevel = "debug",
      ["ruff.nativeServer"] = "on",
    },
  },
}
