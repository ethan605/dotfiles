---@type LazySpec
return {
  "andythigpen/nvim-coverage",
  opts = {
    auto_reload = true,
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = {
    "Coverage",
    "CoverageLoad",
  },
  keys = function()
    local coverage = require("coverage")

    return {
      { "[u", function() coverage.jump_prev("uncovered") end, "Jump to prev uncovered" },
      { "]u", function() coverage.jump_next("uncovered") end, "Jump to next uncovered" },
    }
  end,
}
