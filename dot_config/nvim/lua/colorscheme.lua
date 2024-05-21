vim.cmd([[
  filetype plugin on
  colorscheme snazzy
]])

vim.opt.termguicolors = true

-- Searches
vim.api.nvim_set_hl(0, "Search", { bg = "#f3f99d", fg = "#282a36" }) -- yellow & black
vim.api.nvim_set_hl(0, "CurSearch", { bg = "#9aedfe", fg = "#282a36" }) -- cyan & black
vim.api.nvim_set_hl(0, "IncSearch", { link = "Search" })

-- Line limit column colors
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "NvimDarkGrey4" })

-- Matched parentheses colors
vim.api.nvim_set_hl(0, "MatchParen", { bold = true, fg = "#ff6ac1" }) -- magenta

-- Float panes
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NvimDarkGrey3" })

-- LSP highlights
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ff5c57" }) -- red
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#57c7ff" }) -- blue
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#9aedfe" }) -- cyan
vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = "#5af78e" }) -- green
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#f3f99d" }) -- yellow
