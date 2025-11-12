---@type LazySpec
return {
  "linrongbin16/gitlinker.nvim",
  config = true,
  cmd = "GitLink",
  keys = {
    { "<Leader>gy", ":GitLink<CR>",  mode = { "n", "v" }, desc = "Yank git link" },
    { "<Leader>gY", ":GitLink!<CR>", mode = { "n", "v" }, desc = "Open git link" },
  },
}
