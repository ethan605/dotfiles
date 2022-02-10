local reset_highlight = { guibg = "bg" }

local diagnostics_indicator = function(count, level)
  local icon = level:match("error") and " " or " "
  return " " .. icon .. count
end

require("bufferline").setup {
  highlights = {
    fill = reset_highlight,
    background = reset_highlight,
    buffer_visible = reset_highlight,
    buffer_selected = { gui = "bold" },
    separator = { guifg = "bg", guibg = "bg" },
  },
  options = {
    -- Reset mouse commands
    close_command = nil,
    left_mouse_command = nil,
    middle_mouse_command = nil,
    right_mouse_command = nil,

    -- Diagnostics
    diagnostics = "nvim_lsp",
    diagnostics_indicator = diagnostics_indicator,
    diagnostics_update_in_insert = false,

    -- Displays
    always_show_bufferline = true,
    enforce_regular_tabs = false,
    numbers = "buffer_id",
    offsets = {
      {
        filetype = "NvimTree",
        text = "NvimTree",
        text_align = "center",
      },
    },
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
  },
}
