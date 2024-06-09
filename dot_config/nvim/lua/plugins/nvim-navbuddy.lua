return {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "SmiteshP/nvim-navic",
    "neovim/nvim-lspconfig",
  },
  opts = {
    window = {
      border = "none",
      size = "60%",
      position = { row = "0%", col = "100%" },
      sections = {
        left = {
          size = "35%",
        },
        mid = {
          size = "35%",
        },
        right = {
          preview = "never",
        },
      },
    },
    node_markers = {
      enabled = true,
      icons = {
        leaf = "  ",
        leaf_selected = " → ",
        branch = "  ",
      },
    },
    lsp = {
      auto_attach = true,
    },
  },
}
