---@type LazySpec
return {
  "ggandor/leap.nvim",
  keys = {
    { "<leader>s", "<Plug>(leap-forward)", mode = { "n", "x", "o" }, desc = "Leap forward" },
    { "<leader>S", "<Plug>(leap-backward)", mode = { "n", "x", "o" }, desc = "Leap backward" },
  },
}
