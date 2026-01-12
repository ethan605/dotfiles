local supported_filetypes = {
  "markdown",
  "norg",
  "org",
  "rmd",
  "typst",
  "vimwiki",
}

---@type LazySpec
return {
  "OXY2DEV/markview.nvim",
  ft = supported_filetypes,
  ---@type markview.config
  opts = {
    preview = {
      filetypes = supported_filetypes,
      icon_provider = "internal",
      ignore_buftypes = { "nofile" },
      max_buf_lines = 9999,
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
