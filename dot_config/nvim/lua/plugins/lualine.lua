require("lualine").setup {
  options = {
    component_separators = "",
    section_separators = "",
    theme = "powerline",
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
  }
}
