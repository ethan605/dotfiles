---@type LazyPluginSpec
return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function() require("dbee").install() end,
  config = function()
    local target = os.getenv("SQL_TARGET") or "postgres"

    ---@module "dbee"
    ---@type Config
    local cfg = {
      sources = {
        require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
      },
      editor = {
        directory = vim.fn.expand("~/work/scratch-pad/sql/dbee/" .. target),
        mappings = {
          { key = "<Leader>e", mode = "v", action = "run_selection" },
        },
      },
    }

    require("dbee").setup(cfg)
  end,
}
