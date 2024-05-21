local default_style = { bg = "none", bold = false }
local selected_style = { bg = "none", bold = true }

local diagnostics_indicator = function(count, level)
  local icon = level:match("error") and " " or " "
  return " " .. icon .. count
end

require("bufferline").setup({
  highlights = {
    fill = default_style,
    background = default_style,
    duplicate = default_style,
    pick = default_style,

    -- Default styles
    diagnostic = default_style,
    error = default_style,
    error_diagnostic = default_style,
    hint = default_style,
    hint_diagnostic = default_style,
    info = default_style,
    info_diagnostic = default_style,
    modified = default_style,
    numbers = default_style,
    warning = default_style,
    warning_diagnostic = default_style,

    -- Selected styles
    buffer_selected = selected_style,
    modified_selected = selected_style,
    numbers_selected = selected_style,
    error_diagnostic_selected = { link = "DiagnosticError" },
    error_selected = { link = "DiagnosticError" },
    hint_diagnostic_selected = { link = "DiagnosticHint" },
    hint_selected = { link = "DiagnosticHint" },
    info_diagnostic_selected = { link = "DiagnosticOk" },
    info_selected = { link = "DiagnosticOk" },
    warning_diagnostic_selected = { link = "DiagnosticWarn" },
    warning_selected = { link = "DiagnosticWarn" },

    -- Visible styles
    buffer_visible = default_style,
    diagnostic_visible = default_style,
    error_diagnostic_visible = default_style,
    error_visible = default_style,
    hint_diagnostic_visible = default_style,
    hint_visible = default_style,
    info_diagnostic_visible = default_style,
    info_visible = default_style,
    modified_visible = default_style,
    numbers_visible = selected_style,
    warning_diagnostic_visible = default_style,
    warning_visible = default_style,

    tab = default_style,
    tab_selected = { bg = "NvimDarkGrey1", bold = true, fg = "#9aedfe" },
    tab_separator = { bg = "#282a36", fg = "#282a36" },
    tab_separator_selected = { bg = "NvimDarkGrey1", fg = "NvimDarkGrey1" },
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
    separator_style = { "", "" },
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

    -- Pinning
    groups = {
      items = {
        require("bufferline.groups").builtin.pinned:with({ icon = "" }),
      },
    },
  },
})
