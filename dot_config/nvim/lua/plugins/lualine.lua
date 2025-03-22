return {
  "hoob3rt/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    require("plugins.lsp-progress"), ---@diagnostic disable-line: different-requires
    {
      "SmiteshP/nvim-navic",
      dependencies = { "neovim/nvim-lspconfig" },
      opts = {
        highlight = true,
        lsp = {
          auto_attach = true,
          preference = nil,
        },
      },
    },
  },
  config = function()
    local custom_powerline = require("lualine.themes.powerline")
    local lualine = require("lualine")

    ---@diagnostic disable-next-line: different-requires
    local snazzy_colors = require("lua.colorscheme").snazzy_colors

    local function render_lsp_progress()
      ---@diagnostic disable-next-line: different-requires
      return require("lsp-progress").progress()
    end

    custom_powerline.normal.c.bg = snazzy_colors.black
    custom_powerline.inactive.c.bg = snazzy_colors.black

    lualine.setup({
      options = {
        component_separators = "",
        icons_enabled = true,
        section_separators = "",
        theme = custom_powerline,
        disabled_filetypes = { "NvimTree" },
      },
      extensions = { "oil" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "branch", icon = "" },
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
            fmt = function(text) return string.gsub(text, "%%%*$", "") end,
          },
        },
        lualine_x = {
          {
            render_lsp_progress,
            color = { fg = snazzy_colors.white },
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "branch", icon = "" },
          "diff",
          { "diagnostics", colored = false },
        },
        lualine_c = { "filename" },
        lualine_x = {
          render_lsp_progress,
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })

    -- For lsp-progress
    vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = "lualine_augroup",
      pattern = "LspProgressStatusUpdated",
      callback = lualine.refresh,
    })
  end,
}
