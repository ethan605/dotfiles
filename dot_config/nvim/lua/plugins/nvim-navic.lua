---@type LazyPluginSpec
return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  ---@module "nvim-navic"
  ---@type Options
  opts = {
    click = true,
    highlight = true,
    lsp = {
      auto_attach = true,
      preference = {
        -- python LSP
        "pyrefly",
        "pyright",
      },
    },
  },
}
