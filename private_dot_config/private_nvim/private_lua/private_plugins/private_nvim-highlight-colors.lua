---@type LazyPluginSpec
return {
  "brenoprata10/nvim-highlight-colors",
  opts = {
    render = "background",
    virtual_symbol_position = "inline",
    exclude_filetypes = { "man", "txt" },

    ---Highlight hex colors, e.g. '#FFFFFF'
    enable_hex = true,

    ---Highlight short hex colors e.g. '#fff'
    enable_short_hex = true,

    ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
    enable_rgb = true,

    ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
    enable_hsl = true,

    ---Highlight ansi colors, e.g '\033[0;34m'
    enable_ansi = true,

    ---Highlight xterm 256 (8bit) colors, e.g '\033[38;5;118m'
    enable_xterm256 = true,

    ---Highlight xterm True Color (24bit) colors, e.g '\033[38;2;118;64;90m'
    enable_xtermTrueColor = true,

    -- Highlight hsl colors without function, e.g. '--foreground: 0 69% 69%;'
    enable_hsl_without_function = true,

    ---Highlight CSS variables, e.g. 'var(--testing-color)'
    enable_var_usage = true,

    ---Highlight named colors, e.g. 'green'
    enable_named_colors = true,

    ---Highlight tailwind colors, e.g. 'bg-blue-500'
    enable_tailwind = false,

    custom_colors = {
      { label = "black",            color = "#282a36" },
      -- { label = "red",              color = "#ff5c57" },
      { label = "green",            color = "#5af78e" },
      { label = "yellow",           color = "#f3f99d" },
      { label = "blue",             color = "#57c7ff" },
      { label = "magenta",          color = "#ff6ac1" },
      { label = "cyan",             color = "#9aedfe" },
      { label = "white",            color = "#eff0eb" },
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
