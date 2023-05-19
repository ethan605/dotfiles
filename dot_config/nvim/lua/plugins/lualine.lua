local custom_powerline = require("lualine.themes.powerline")

-- Snazzy colours
local custom_colors = {
  black = "282a36"
}

custom_powerline.normal.c.bg = custom_colors.black
custom_powerline.inactive.c.bg = custom_colors.black

require("lualine").setup {
  options = {
    component_separators = "",
    icons_enabled = true,
    section_separators = "",
    theme = custom_powerline,
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {
      { "branch", icon = "" },
      "diff",
      "diagnostics"
    },
    lualine_c = {"filename"},
    lualine_x = {"encoding", "fileformat", "filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"}
  },
  inactive_sections = {
    lualine_a = {"mode"},
    lualine_b = {
      { "branch", icon = "" },
      "diff",
      "diagnostics"
    },
    lualine_c = {"filename"},
    lualine_x = {"encoding", "fileformat", "filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"}
  }
}
