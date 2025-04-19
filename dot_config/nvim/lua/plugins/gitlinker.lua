---@type LazySpec
return {
  "linrongbin16/gitlinker.nvim",
  opts = {},
  cmd = "GitLink",
  keys = {
    { "<leader>gy", "<cmd>GitLink<cr>",  mode = { "n", "v" }, desc = "Yank git link" },
    { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
  },
}
