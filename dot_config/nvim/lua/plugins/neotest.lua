---@type LazySpec
return {
  "nvim-neotest/neotest",
  dependencies = {
    "antoinemadec/FixCursorHold.nvim",
    "marilari88/neotest-vitest",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-python",
    "nvim-neotest/nvim-nio",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = function()
    ---@type neotest.Config
    ---@diagnostic disable-next-line: missing-fields
    return {
      adapters = {
        require("neotest-python"),
        require("neotest-vitest"),
      },
      status = {
        enabled = true,
        virtual_text = true,
        signs = true,
      },
      ---@diagnostic disable-next-line: missing-fields
      summary = {
        open = "botright vsplit | vertical resize 80",
        ---@diagnostic disable-next-line: missing-fields
        mappings = {
          expand = "l",
          parent = "P",
          output = "o",
          jumpto = "i",
          stop = "u",
          run = "r",
          mark = "m",
          run_marked = "R",
          clear_marked = "M",
          next_failed = "J",
          prev_failed = "K",
          help = "?",
        },
      },
    }
  end,
  keys = function()
    local neotest = require("neotest")

    return {
      { "<Leader>ta", function() neotest.run.run(vim.fn.expand("%")) end,   mode = { "n" }, desc = "Run all tests" },
      { "<Leader>tr", function() neotest.run.run() end,                     mode = { "n" }, desc = "Run nearest test" },
      { "<Leader>to", function() neotest.output.open({ enter = true }) end, mode = { "n" }, desc = "View test runner output" },
      { "<Leader>ts", function() neotest.summary.open() end,                mode = { "n" }, desc = "View tests summary" },
    }
  end,
}
