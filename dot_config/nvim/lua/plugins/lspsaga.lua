return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    symbol_in_winbar = {
      enable = false,
    },
    outline = {
      layout = "float",
      max_height = 0.75,
      left_width = 0.25,
    },
  },
}
