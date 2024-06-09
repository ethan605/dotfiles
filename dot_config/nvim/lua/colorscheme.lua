vim.cmd([[
  filetype plugin on
  colorscheme snazzy
]])

vim.opt.termguicolors = true

local snazzy_colors = {
  gray = "NvimDarkGrey4",
  black = "#282a36",
  blue = "#57c7ff",
  cyan = "#9aedfe",
  green = "#5af78e",
  magenta = "#ff6ac1",
  red = "#ff5c57",
  white = "#eff0eb",
  yellow = "#f3f99d",
}

-- Searches
vim.api.nvim_set_hl(0, "Search", { bg = snazzy_colors.yellow, fg = snazzy_colors.black })
vim.api.nvim_set_hl(0, "CurSearch", { bg = snazzy_colors.cyan, fg = snazzy_colors.black })
vim.api.nvim_set_hl(0, "IncSearch", { link = "Search" })

-- Matched parentheses colors
vim.api.nvim_set_hl(0, "MatchParen", { bold = true, fg = snazzy_colors.magenta })

-- Float windows
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#3a3a3a" })

-- For nvim-foldsign
vim.api.nvim_set_hl(0, "FoldColumn", { fg = snazzy_colors.gray })

-- For dropbar.nvim
vim.api.nvim_set_hl(0, "WinBar", {})   -- clear
vim.api.nvim_set_hl(0, "WinBarNC", {}) -- clear

-- For fzf-lua
vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = snazzy_colors.gray })
vim.api.nvim_set_hl(0, "FzfLuaBufNr", { fg = snazzy_colors.yellow })
vim.api.nvim_set_hl(0, "FzfLuaBufName", { fg = snazzy_colors.magenta })
vim.api.nvim_set_hl(0, "FzfLuaTabMarker", { link = "FzfLuaBufNr" })
vim.api.nvim_set_hl(0, "FzfLuaHeaderBind", { link = "FzfLuaBufNr" })

-- LSP highlights
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = snazzy_colors.red })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = snazzy_colors.blue })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = snazzy_colors.cyan })
vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = snazzy_colors.green })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = snazzy_colors.yellow })

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = snazzy_colors.red })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = snazzy_colors.blue })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = snazzy_colors.cyan })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineOk", { undercurl = true, sp = snazzy_colors.green })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = snazzy_colors.yellow })
vim.api.nvim_set_hl(0, "DiagnosticDeprecated", { strikethrough = true, fg = snazzy_colors.gray })

-- Override default Nvim palettes
vim.api.nvim_set_hl(0, "Added", { fg = snazzy_colors.green })
vim.api.nvim_set_hl(0, "RedrawDebugComposed", { bg = snazzy_colors.green })

vim.api.nvim_set_hl(0, "Question", { fg = snazzy_colors.cyan })
vim.api.nvim_set_hl(0, "QuickFixLine", { bg = snazzy_colors.cyan })
vim.api.nvim_set_hl(0, "Changed", { bg = snazzy_colors.cyan })

vim.api.nvim_set_hl(0, "Removed", { fg = snazzy_colors.red })
vim.api.nvim_set_hl(0, "RedrawDebugRecompose", { bg = snazzy_colors.red })

vim.api.nvim_set_hl(0, "RedrawDebugClear", { bg = snazzy_colors.yellow })

return {
  snazzy_colors = snazzy_colors,
}
