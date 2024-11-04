return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  opts = {
    preview = {
      win_config = {
        winblend = 1,
        winhighlight = "Normal:Normal,FloatBorder:FoldColumn",
      },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
        jumpTop = "[",
        jumpBot = "]",
      },
    },
  },
}
