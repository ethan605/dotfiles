vim.cmd([[
  filetype plugin on
  colorscheme snazzy
]])

vim.opt.termguicolors = true

local snazzy_colors = {
  -- gray = "NvimDarkGrey4",
  gray = "#606580",
  black = "#282a36",
  blue = "#57c7ff",
  cyan = "#9aedfe",
  green = "#5af78e",
  magenta = "#ff6ac1",
  red = "#ff5c57",
  white = "#eff0eb",
  yellow = "#f3f99d",
}

-- Built-ins
vim.api.nvim_set_hl(0, "Comment", { italic = true, fg = snazzy_colors.gray })
vim.api.nvim_set_hl(0, "NonText", { link = "Comment" })
vim.api.nvim_set_hl(0, "Search", { bg = snazzy_colors.yellow, fg = snazzy_colors.black })
vim.api.nvim_set_hl(0, "CurSearch", { bg = snazzy_colors.cyan, fg = snazzy_colors.black })
vim.api.nvim_set_hl(0, "IncSearch", { link = "Search" })
vim.api.nvim_set_hl(0, "WinBar", {})   -- clear
vim.api.nvim_set_hl(0, "WinBarNC", {}) -- clear

-- Matched parentheses colors
vim.api.nvim_set_hl(0, "MatchParen", { bold = true, fg = snazzy_colors.magenta })

-- Float windows
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#3a3a3a" })

-- For nvim-foldsign
vim.api.nvim_set_hl(0, "FoldColumn", { fg = snazzy_colors.gray })

-- For fzf-lua
vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = snazzy_colors.gray })
vim.api.nvim_set_hl(0, "FzfLuaBufNr", { fg = snazzy_colors.yellow })
vim.api.nvim_set_hl(0, "FzfLuaBufName", { fg = snazzy_colors.magenta })
vim.api.nvim_set_hl(0, "FzfLuaTabMarker", { link = "FzfLuaBufNr" })
vim.api.nvim_set_hl(0, "FzfLuaHeaderBind", { link = "FzfLuaBufNr" })

-- For nvim-navic
vim.api.nvim_set_hl(0, "NavicIconsArray", { link = "Structure" })
vim.api.nvim_set_hl(0, "NavicIconsBoolean", { link = "Boolean" })
vim.api.nvim_set_hl(0, "NavicIconsClass", { link = "Structure" })
vim.api.nvim_set_hl(0, "NavicIconsConstant", { link = "Constant" })
vim.api.nvim_set_hl(0, "NavicIconsConstructor", { link = "Structure" })
vim.api.nvim_set_hl(0, "NavicIconsEnum", { link = "Type" })
vim.api.nvim_set_hl(0, "NavicIconsEnum_member", { link = "Identifier" })
vim.api.nvim_set_hl(0, "NavicIconsEvent", { link = "Type" })
vim.api.nvim_set_hl(0, "NavicIconsField", { link = "Identifier" })
vim.api.nvim_set_hl(0, "NavicIconsFile", { link = "Structure" })
vim.api.nvim_set_hl(0, "NavicIconsFunction", { link = "Function" })
vim.api.nvim_set_hl(0, "NavicIconsInterface", { link = "Type" })
vim.api.nvim_set_hl(0, "NavicIconsKey", { link = "Identifier" })
vim.api.nvim_set_hl(0, "NavicIconsMethod", { link = "Function" })
vim.api.nvim_set_hl(0, "NavicIconsModule", { link = "Structure" })
vim.api.nvim_set_hl(0, "NavicIconsNamespace", { link = "Structure" })
vim.api.nvim_set_hl(0, "NavicIconsNull", { link = "Special" })
vim.api.nvim_set_hl(0, "NavicIconsNumber", { link = "Number" })
vim.api.nvim_set_hl(0, "NavicIconsObject", { link = "Structure" })
vim.api.nvim_set_hl(0, "NavicIconsOperator", { link = "Operator" })
vim.api.nvim_set_hl(0, "NavicIconsPackage", { link = "Structure" })
vim.api.nvim_set_hl(0, "NavicIconsProperty", { link = "Identifier" })
vim.api.nvim_set_hl(0, "NavicIconsString", { link = "String" })
vim.api.nvim_set_hl(0, "NavicIconsStruct", { link = "Structure" })
vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { link = "Type" })
vim.api.nvim_set_hl(0, "NavicIconsVariable", { link = "Identifier" })
vim.api.nvim_set_hl(0, "NavicSeparator", { fg = snazzy_colors.gray })
vim.api.nvim_set_hl(0, "NavicText", { fg = snazzy_colors.white })

-- For leap.nvim
vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = snazzy_colors.gray })
vim.api.nvim_set_hl(0, "LeapMatch", { fg = snazzy_colors.yellow, bold = true, nocombine = true })
vim.api.nvim_set_hl(0, "LeapLabel", { fg = snazzy_colors.magenta, bold = true, nocombine = true })

-- LSP highlights
vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })

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
