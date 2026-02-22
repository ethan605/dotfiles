---@type vim.lsp.Config
return {
  cmd = { "postgrestools", "lsp-proxy" },
  filetypes = { "sql", "plsql" },
  root_markers = { "postgrestools.jsonc" },
}
