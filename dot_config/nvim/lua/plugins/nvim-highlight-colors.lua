---@type LazySpec
return {
  "brenoprata10/nvim-highlight-colors",
  opts = {
    render = "background",
    virtual_symbol_position = "inline",
    enable_tailwind = true,

    custom_colors = {
      { label = "bright-black",     color = "#686868" },

      -- Default Neovim palettes
      -- https://github.com/neovim/neovim/blob/release-0.10/src/nvim/highlight_group.c#L2909-L2939
      { label = "NvimDarkBlue",     color = "#004c73" },
      { label = "NvimDarkCyan",     color = "#007373" },
      { label = "NvimDarkGray1",    color = "#07080d" },
      { label = "NvimDarkGray2",    color = "#14161b" },
      { label = "NvimDarkGray3",    color = "#2c2e33" },
      { label = "NvimDarkGray4",    color = "#4f5258" },
      { label = "NvimDarkGreen",    color = "#005523" },
      { label = "NvimDarkGrey1",    color = "#07080d" },
      { label = "NvimDarkGrey2",    color = "#14161b" },
      { label = "NvimDarkGrey3",    color = "#2c2e33" },
      { label = "NvimDarkGrey4",    color = "#4f5258" },
      { label = "NvimDarkMagenta",  color = "#470045" },
      { label = "NvimDarkRed",      color = "#590008" },
      { label = "NvimDarkYellow",   color = "#6b5300" },
      { label = "NvimLightBlue",    color = "#a6dbff" },
      { label = "NvimLightCyan",    color = "#8cf8f7" },
      { label = "NvimLightGray1",   color = "#eef1f8" },
      { label = "NvimLightGray2",   color = "#e0e2ea" },
      { label = "NvimLightGray3",   color = "#c4c6cd" },
      { label = "NvimLightGray4",   color = "#9b9ea4" },
      { label = "NvimLightGreen",   color = "#b3f6c0" },
      { label = "NvimLightGrey1",   color = "#eef1f8" },
      { label = "NvimLightGrey2",   color = "#e0e2ea" },
      { label = "NvimLightGrey3",   color = "#c4c6cd" },
      { label = "NvimLightGrey4",   color = "#9b9ea4" },
      { label = "NvimLightMagenta", color = "#ffcaff" },
      { label = "NvimLightRed",     color = "#ffc0b9" },
      { label = "NvimLightYellow",  color = "#fce094" },
    },
  },
}
