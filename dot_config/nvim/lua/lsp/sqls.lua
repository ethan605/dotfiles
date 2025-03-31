---@class vim.lsp.Config
return {
  cmd = {
    "sqls",
    "-config",
    vim.fn.expand("~/.config/sqls/config.yml"),
  },
  filetypes = { "sql", "mysql", "plsql" },
}
