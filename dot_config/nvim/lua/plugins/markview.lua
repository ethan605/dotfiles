local supported_filetypes = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" }
---@type LazySpec
return {
  "OXY2DEV/markview.nvim",
  ft = supported_filetypes,
  ---@type mkv.config
  opts = {
    preview = {
      filetypes = supported_filetypes,
      ignore_buftypes = {},
      max_buf_lines = 9999,
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
