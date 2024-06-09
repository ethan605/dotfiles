return {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    require("ibl").setup({
      indent = { char = "·", tab_char = "·" },
      whitespace = { remove_blankline_trail = true },
      scope = {
        char = "│",
        highlight = { "Function", "Label" },
        show_exact_scope = true,
      },
      exclude = {
        filetypes = { "dashboard", "startify" },
      },
    })
  end,
}
