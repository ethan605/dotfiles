local no_bg_style = { guibg = "none" }
local bold_only_style = { gui = "bold" }

local diagnostics_indicator = function(count, level)
  local icon = level:match("error") and " " or " "
  return " " .. icon .. count
end

require("bufferline").setup {
  highlights = {
    fill = no_bg_style,
    background = no_bg_style,

    -- Selected styles
    buffer_selected = bold_only_style,
    error_diagnostic_selected = bold_only_style,
    error_selected = bold_only_style,
    hint_diagnostic_selected = bold_only_style,
    hint_selected = bold_only_style,
    info_diagnostic_selected = bold_only_style,
    info_selected = bold_only_style,
    warning_diagnostic_selected = bold_only_style,
    warning_selected = bold_only_style,

    -- Visible styles
    buffer_visible = no_bg_style,
    diagnostic_visible = no_bg_style,
    error_diagnostic_visible = no_bg_style,
    error_visible = no_bg_style,
    hint_diagnostic_visible = no_bg_style,
    hint_visible = no_bg_style,
    info_diagnostic_visible = no_bg_style,
    info_visible = no_bg_style,
    warning_diagnostic_visible = no_bg_style,
    warning_visible = no_bg_style,

    -- Default styles
    diagnostic = no_bg_style,
    error = no_bg_style,
    error_diagnostic = no_bg_style,
    hint = no_bg_style,
    hint_diagnostic = no_bg_style,
    info = no_bg_style,
    info_diagnostic = no_bg_style,
    warning = no_bg_style,
    warning_diagnostic = no_bg_style,

    duplicate = no_bg_style,
    pick = no_bg_style,
  },
  options = {
    -- Diagnostics
    diagnostics = "nvim_lsp",
    diagnostics_indicator = diagnostics_indicator,
    diagnostics_update_in_insert = false,

    -- Displays
    always_show_bufferline = true,
    enforce_regular_tabs = false,
    numbers = "buffer_id",
    separator_style = {"", ""},
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,

    -- Side bar
    offsets = {
      {
        filetype = "NvimTree",
        highlight = "Directory",
        text = "NvimTree",
        text_align = "center",
      },
    },
  },
}
