---@type LazySpec
return {
  "mistweaverco/kulala.nvim",
  opts = {},
  ft = { "http", "rest" },
  keys = {
    { "<leader>Rb", function() require("kulala").scratchpad() end, mode = { "n", "v" }, desc = "Kulala scratchpad" },
    { "<leader>Rs", function() require("kulala").run() end,        mode = { "n", "v" }, desc = "Kulala run" },
  },
}
