local reset_highlight = { guibg = "none" }

local diagnostics_indicator = function(count, level)
  local icon = level:match("error") and " " or " "
  return " " .. icon .. count
end

require("bufferline").setup {
  highlights = {
    fill = reset_highlight,
    background = reset_highlight,

    buffer_selected = { gui = "bold" },
    buffer_visible = reset_highlight,

    duplicate = reset_highlight,
    pick = reset_highlight,
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
