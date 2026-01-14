---@type LazyPluginSpec
return {
  "ggandor/leap.nvim",
  keys = {
    { "<Leader>s", "<Plug>(leap-forward)",  mode = { "n", "x", "o" }, desc = "Leap forward" },
    { "<Leader>S", "<Plug>(leap-backward)", mode = { "n", "x", "o" }, desc = "Leap backward" },
  },
}
