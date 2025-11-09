---@type LazySpec
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  ---@type TodoOptions
  opts = {
    signs = true,
    sign_priority = 11,
    keywords = {
      FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "HACK" } },
      TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      TODO = { icon = " ", color = "info", alt = { "NOTE", "INFO" } },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "DANGER", "ALARM" } },
    },
  },
}
