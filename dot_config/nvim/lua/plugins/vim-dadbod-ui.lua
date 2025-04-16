---@type LazySpec
return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    "tpope/vim-dadbod",
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
  },
  keys = {
    { "<leader>e", "<Plug>(DBUI_ExecuteQuery)", mode = "v", desc = "Execute selected query" },
    { "<leader>w", "<Plug>(DBUI_SaveQuery)",    mode = "n", desc = "Save current query" },
  },
}
