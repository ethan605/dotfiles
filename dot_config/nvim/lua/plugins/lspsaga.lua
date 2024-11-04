return {
  "nvimdev/lspsaga.nvim",
  dependencies = { "nvim-lspconfig" },
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
