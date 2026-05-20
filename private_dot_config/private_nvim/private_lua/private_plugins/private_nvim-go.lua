---@type LazyPluginSpec
return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
}
