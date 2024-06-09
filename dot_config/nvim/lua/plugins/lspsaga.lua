return {
  "nvimdev/lspsaga.nvim",
  dependencies = { "nvim-lspconfig" },
  config = function()
    require("lspsaga").setup({
      symbol_in_winbar = {
        enable = false,
      },
      outline = {
        layout = "float",
        max_height = 0.75,
        left_width = 0.25,
      },
    })
  end,
}
