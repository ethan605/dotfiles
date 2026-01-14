---@type LazyPluginSpec
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      ensure_installed = "all",
      highlight = {
        enable = true,
        disable = { "csv", "tsv" },
      },
      ignore_install = { "ipkg" },
      modules = {},
      sync_install = false,
    })
  end,
}
