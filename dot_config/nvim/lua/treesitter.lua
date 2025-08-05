require("nvim-treesitter.configs").setup({
  auto_install = true,
  ensure_installed = "all",
  highlight = { enable = true },
  ignore_install = { "ipkg" },
  modules = {},
  sync_install = false,
})
