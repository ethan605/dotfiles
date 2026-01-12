local function get_driver()
  local target = os.getenv("SQL_TARGET") or "postgres"
  return target == "postgres" and "postgresql" or "clickhouse"
end

---@type vim.lsp.Config
return {
  cmd = { "sqls" },
  filetypes = { "sql", "mysql", "plsql" },
  settings = {
    sqls = {
      connections = {
        {
          driver = get_driver(),
          dataSourceName = os.getenv("SQLS_CONNECTION_URI"),
        },
      },
    },
  },
}
