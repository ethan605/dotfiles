---@type LazySpec
return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function() require("dbee").install() end,
  config = function()
    ---@type Config
    local cfg = {
      sources = {
        require("dbee.sources").EnvSource:new("DBEE_POSTGRES_CONNECTIONS"),
        require("dbee.sources").EnvSource:new("DBEE_CLICKHOUSE_CONNECTIONS"),
      },
      editor = {
        directory = vim.fn.expand("~/work/scratch-pad/sql"),
        mappings = {
          { key = "<Leader>e", mode = "v", action = "run_selection" },
        },
      },
    }

    require("dbee").setup(cfg)
  end,
}
