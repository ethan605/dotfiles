---@type LazySpec
return {
  "yorickpeterse/nvim-window",
  keys = {
    { "<C-w><C-s>", function() require("nvim-window").pick() end, mode = { "n" }, desc = "Pick window" },
  },
  opts = {
    chars = { "a", "s", "d", "f", "h", "j", "k", "l" },
    normal_hl = "LeapLabel",
    render = "float",
  },
}
