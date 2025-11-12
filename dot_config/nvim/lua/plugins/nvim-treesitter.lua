---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  opts = {
    auto_install = true,
    ensure_installed = "all",
    highlight = { enable = true },
    ignore_install = { "ipkg" },
    modules = {},
    sync_install = false,
  },
}
