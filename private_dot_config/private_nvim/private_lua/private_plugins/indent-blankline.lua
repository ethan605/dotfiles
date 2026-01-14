---@type LazyPluginSpec
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@type ibl.config
  opts = {
    indent = { char = "·", tab_char = "·" },
    whitespace = { remove_blankline_trail = true },
    scope = {
      char = "│",
      highlight = { "Function", "Label" },
      show_exact_scope = true,
    },
    exclude = {
      filetypes = { "dashboard", "NvimTree" },
    },
  },
}
