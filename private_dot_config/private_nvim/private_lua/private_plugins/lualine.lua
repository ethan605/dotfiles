local custom_modules = {
  branch = { "branch", icon = "" },
  encoding = { "encoding", show_bomb = true },
  filename = {
    "filename",
    cond = function()
      return vim.o.buftype ~= "terminal"
    end,
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

local function custom_theme_powerline()
  local colors = require("lua.colorscheme").snazzy_colors
  local powerline = require("lualine.themes.powerline")

  powerline.normal.c.fg = colors.white
  powerline.normal.c.bg = colors.black
  powerline.inactive.c.bg = colors.black
  powerline.inactive.c.fg = colors.gray

  return powerline
end

---@type LazyPluginSpec
return {
  "hoob3rt/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    require("plugins.nvim-navic"),
  },
  opts = function()
    return {
      options = {
        component_separators = "",
        disabled_filetypes = { "dbee", "DiffviewFiles" },
        globalstatus = false, -- enabling allows terminal-based extensions (fzf, lazy, mason) to work, but pretty funky
        icons_enabled = true,
        section_separators = "",
        theme = custom_theme_powerline(),
      },
      extensions = {
        "nvim-dap-ui",
        "nvim-tree",
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
    }
  end,
}
