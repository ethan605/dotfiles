---@type vim.lsp.Config
return {
  cmd = { "sqruff", "lsp" },
  filetypes = { "sql", "mysql", "plsql" },
  root_markers = { ".sqruff", ".git" },
}
