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
  local custom_powerline = require("lualine.themes.powerline")

  custom_powerline.normal.c.bg = colors.black
  custom_powerline.normal.c.fg = colors.white
  custom_powerline.inactive.c.bg = colors.black
  custom_powerline.inactive.c.fg = colors.white
  custom_powerline.replace.c = custom_powerline.normal.c
  custom_powerline.visual.c = custom_powerline.normal.c

  return custom_powerline
end

local function custom_theme_snazzy()
  local colors = require("lua.colorscheme").snazzy_colors

  local section_c = { fg = colors.white, bg = colors.black }
  local theme_normal = {
    a = { fg = colors.black, bg = colors.green, gui = "bold" },
    b = { fg = colors.black, bg = colors.cyan },
    c = section_c,
  }
  local theme_insert = {
    a = { fg = colors.white, bg = colors.alt_blue, gui = "bold" },
    b = { fg = colors.black, bg = colors.blue },
    c = section_c,
  }

  return {
    normal = theme_normal,
    insert = theme_insert,
    terminal = theme_insert,
    visual = { a = { fg = colors.black, bg = colors.alt_yellow, gui = "bold" } },
    replace = { a = { fg = colors.black, bg = colors.red, gui = "bold" } },
    inactive = {
      a = { fg = colors.gray, bg = colors.black, gui = "bold" },
      b = { fg = colors.gray, bg = colors.black },
      c = { fg = colors.gray, bg = colors.black },
    },
  }
end

---@type LazyPluginSpec
return {
  "hoob3rt/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    require("plugins.nvim-navic"),
  },
  opts = function()
    local theme = os.getenv("LUALINE_THEME") == "snazzy" and custom_theme_snazzy() or custom_theme_powerline()

    return {
      options = {
        component_separators = "",
        -- disabled_filetypes = { "dbee" },
        globalstatus = true,
        icons_enabled = true,
        section_separators = "",
        theme = theme,
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
      extensions = {
        "fzf",
        "lazy",
        "mason",
        "nvim-dap-ui",
        "nvim-tree",
      },
    }
  end,
}
