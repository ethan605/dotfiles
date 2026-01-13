local custom_modules = {
  branch = { "branch", icon = "" },
  encoding = { "encoding", show_bomb = true },
  filename = {
    "filename",
    file_status = true,
    newfile_status = true,
    symbols = {
      modified = "",
      readonly = "󰌾",
      unnamed = "󰛄",
      newfile = "󰝒",
    },
  },
  lsp_status = {
    "lsp_status",
    icon = " ",
    ignore_lsp = { "null-ls" },
    show_name = true,
  },

  ---More compact location
  ---@return string
  location = function()
    local line = vim.fn.line(".")
    local col = vim.fn.charcol(".")
    return string.format("%d:%d", line, col)
  end,

  ---More compact progress
  ---@return string
  progress = function()
    local cur = vim.fn.line(".")
    local total = vim.fn.line("$")
    if cur == 1 then
      return "top"
    elseif cur == total then
      return "bot"
    else
      return string.format("%d%%%%", math.floor(cur / total * 100))
    end
  end,
}

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
    custom_powerline.normal.c.fg = snazzy_colors.white
    custom_powerline.inactive.c.bg = snazzy_colors.black
    custom_powerline.inactive.c.fg = snazzy_colors.white
    custom_powerline.replace.c = custom_powerline.normal.c
    custom_powerline.visual.c = custom_powerline.normal.c

    lualine.setup({
      options = {
        component_separators = "",
        disabled_filetypes = { "NvimTree", "dbee" },
        icons_enabled = true,
        section_separators = "",
        theme = custom_powerline,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          custom_modules.branch,
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
          custom_modules.filename,
          {
            "navic",
            color_correction = "dynamic",
          },
        },
        lualine_x = {
          custom_modules.lsp_status,
          custom_modules.encoding,
          "fileformat",
          "filetype",
        },
        lualine_y = { custom_modules.progress },
        lualine_z = { custom_modules.location },
      },
      inactive_sections = {
        lualine_a = { "mode" },
        lualine_b = {
          custom_modules.branch,
          { "diff", colored = false },
        },
        lualine_c = { custom_modules.filename },
        lualine_x = {
          custom_modules.encoding,
          "fileformat",
          { "filetype", colored = false },
        },
        lualine_y = { custom_modules.progress },
        lualine_z = { custom_modules.location },
      },
    })
  end,
}
