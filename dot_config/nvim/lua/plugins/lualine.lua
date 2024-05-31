local custom_powerline = require("lualine.themes.powerline")
local lualine = require("lualine")
local snazzy_colors = require("lua.colorscheme").snazzy_colors

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
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      { "branch", icon = "" },
      "diff",
      "diagnostics",
    },
    lualine_c = { "filename" },
    lualine_x = {
      {
        function()
          return require("lsp-progress").progress()
        end,
        color = { fg = snazzy_colors.cyan },
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
      "diagnostics",
    },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
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
