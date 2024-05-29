require("nvim-highlight-colors").setup({
  render = "background",
  virtual_symbol_position = "inline",
  enable_tailwind = true,

  custom_colors = {
    -- https://github.com/neovim/neovim/blob/release-0.10/src/nvim/highlight_group.c#L2919
    { label = "NvimDarkGrey1", color = "#07080d" },
    { label = "NvimDarkGrey4", color = "#4f5258" },
  },
})
