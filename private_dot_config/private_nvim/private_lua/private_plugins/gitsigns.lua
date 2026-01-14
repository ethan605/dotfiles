---@type LazyPluginSpec
return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  event = "CursorHold",
  dependencies = { "nvim-lua/plenary.nvim" },
  ---@type Gitsigns.Config
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    sign_priority = 6,
    signcolumn = true, -- :Gitsigns toggle_signs
    numhl = true,      -- :Gitsigns toggle_numhl
    linehl = false,    -- :Gitsigns toggle_linehl
    word_diff = false, -- :Gitsigns toggle_word_diff
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "right_align",
      delay = 500,
      ignore_whitespace = false,
      virt_text_priority = 100,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> • <summary>",
  },
  keys = {
    { "[c", ":Gitsigns prev_hunk<CR>", desc = "Jump to previous hunk" },
    { "]c", ":Gitsigns next_hunk<CR>", desc = "Jump to next hunk" },
  },
}
