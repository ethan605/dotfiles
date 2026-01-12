---More compact location module
---@return string
local function compact_progress()
  local cur = vim.fn.line(".")
  local total = vim.fn.line("$")
  if cur == 1 then
    return "top"
  elseif cur == total then
    return "bot"
  else
    return string.format("%d%%%%", math.floor(cur / total * 100))
  end
end

---More compact location module
---@return string
local function compact_location()
  local line = vim.fn.line(".")
  local col = vim.fn.charcol(".")
  return string.format("%d:%d", line, col)
end

---@type LazySpec
return {
  "hoob3rt/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    require("plugins.nvim-navic"),
  },
  opts = function()
    local lualine = require("lualine")
    local snazzy_colors = require("lua.colorscheme").snazzy_colors

    local custom_powerline = require("lualine.themes.powerline")
    custom_powerline.normal.c.bg = snazzy_colors.black
    custom_powerline.inactive.c.bg = snazzy_colors.black

    local git_branch = { "branch", icon = "" }
    local encoding = { "encoding", show_bomb = true }

    lualine.setup({
      options = {
        component_separators = "",
        icons_enabled = true,
        section_separators = "",
        theme = custom_powerline,
        disabled_filetypes = { "NvimTree", "dbee", "dbui" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          git_branch,
          "diff",
          {
            "diagnostics",
            diagnostics_color = {
              error = "DiagnosticError",
              warn = "DiagnosticWarn",
              info = "DiagnosticInfo",
              hint = "DiagnosticHint",
            },
          },
        },
        lualine_c = {
          "filename",
          {
            "navic",
            color_correction = "dynamic",
          },
        },
        lualine_x = {
          {
            "lsp_status",
            icon = " ",
            ignore_lsp = { "null-ls" },
            show_name = true,
          },
          encoding,
          "fileformat",
          "filetype",
        },
        lualine_y = { compact_progress },
        lualine_z = { compact_location },
      },
      inactive_sections = {
        lualine_a = { "mode" },
        lualine_b = {
          git_branch,
          { "diff", colored = false },
        },
        lualine_c = { "filename" },
        lualine_x = {
          encoding,
          "fileformat",
          { "filetype", colored = false },
        },
        lualine_y = { compact_progress },
        lualine_z = { compact_location },
      },
    })
  end,
}
