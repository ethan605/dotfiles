---@return string
local function diagnostics_indicator(count, level)
  local icon = " "

  if level:match("error") then
    icon = " "
  elseif level:match("warning") then
    icon = " "
  end

  return icon .. count
end

---@type LazyPluginSpec
return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local snazzy_colors = require("lua.colorscheme").snazzy_colors

    ---@type bufferline.HLGroup
    local clear_bg = { bg = snazzy_colors.black }
    local default_style = vim.tbl_extend("keep", clear_bg, { bold = false, italic = true })
    local selected_style = vim.tbl_extend("keep", clear_bg, { bold = true, italic = false })
    local pick_style = vim.tbl_extend("keep", default_style, { fg = snazzy_colors.green })
    local pick_selected_style = vim.tbl_extend("keep", selected_style, { fg = snazzy_colors.red })
    local error_style = vim.tbl_extend("keep", clear_bg, { fg = snazzy_colors.red })
    local error_selected_style = vim.tbl_extend("keep", error_style, { italic = false })
    local hint_style = vim.tbl_extend("keep", clear_bg, { fg = snazzy_colors.blue })
    local hint_selected_style = vim.tbl_extend("keep", hint_style, { italic = false })
    local info_style = vim.tbl_extend("keep", clear_bg, { fg = snazzy_colors.green })
    local info_selected_style = vim.tbl_extend("keep", info_style, { italic = false })
    local warn_style = vim.tbl_extend("keep", clear_bg, { fg = snazzy_colors.yellow })
    local warn_selected_style = vim.tbl_extend("keep", warn_style, { italic = false })

    ---@type bufferline.UserConfig
    return {
      highlights = {
        fill = default_style,
        background = default_style,
        duplicate = default_style,
        trunc_marker = default_style,

        -- Default styles
        diagnostic = default_style,
        modified = default_style,
        numbers = default_style,
        pick = pick_style,

        error = default_style,
        error_diagnostic = default_style,
        hint = default_style,
        hint_diagnostic = default_style,
        info = default_style,
        info_diagnostic = default_style,
        warning = default_style,
        warning_diagnostic = default_style,

        -- Selected styles
        buffer_selected = selected_style,
        diagnostic_selected = selected_style,
        modified_selected = selected_style,
        numbers_selected = selected_style,
        pick_selected = pick_selected_style,

        error_diagnostic_selected = error_selected_style,
        error_selected = error_selected_style,
        hint_diagnostic_selected = hint_selected_style,
        hint_selected = hint_selected_style,
        info_diagnostic_selected = info_selected_style,
        info_selected = info_selected_style,
        warning_diagnostic_selected = warn_selected_style,
        warning_selected = warn_selected_style,

        -- Visible styles
        buffer_visible = default_style,
        diagnostic_visible = default_style,
        modified_visible = default_style,
        numbers_visible = selected_style,
        pick_visible = pick_style,

        error_diagnostic_visible = default_style,
        error_visible = default_style,
        hint_diagnostic_visible = default_style,
        hint_visible = default_style,
        info_diagnostic_visible = default_style,
        info_visible = default_style,
        warning_diagnostic_visible = default_style,
        warning_visible = default_style,

        -- Tab styles
        tab = { bg = snazzy_colors.black, bold = false, italic = false },
        tab_selected = { bg = "NvimDarkGrey1", bold = true, fg = snazzy_colors.blue },
        tab_separator = { bg = snazzy_colors.black, fg = snazzy_colors.black },
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
          options = {
            toggle_hidden_on_enter = true,
          },
          items = {
            require("bufferline.groups").builtin.pinned:with({ icon = "" }),
          },
        },
      },
    }
  end,
  lazy = false,
  keys = {
    { "g[", ":BufferLineCyclePrev<CR>", desc = "Switch to left buffer" },
    { "g]", ":BufferLineCycleNext<CR>", desc = "Switch to right buffer" },
    { "g{", ":BufferLineMovePrev<CR>",  desc = "Move buffer to left" },
    { "g}", ":BufferLineMoveNext<CR>",  desc = "Move buffer to right" },
    { "gs", ":BufferLinePick<CR>",      desc = "Pick buffer" },
    { "gq", ":BufferLinePickClose<CR>", desc = "Pick buffer to close" },
    { "gC", ":bdelete!<CR>",            desc = "Close buffer" },
    { "gc", ":close<CR>",               desc = "Force close buffer" },
    { "t[", ":tabprevious<CR>",         desc = "Switch to left tab" },
    { "t]", ":tabnext<CR>",             desc = "Switch to right tab" },
  },
}
