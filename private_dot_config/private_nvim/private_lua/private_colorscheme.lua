local snazzy_colors = {
  -- gray = "NvimDarkGrey4",
  gray      = "#78787e", -- base03
  dark_gray = "#34353e", -- base01
  black     = "#282a36",
  blue      = "#57c7ff",
  cyan      = "#9aedfe",
  green     = "#5af78e",
  magenta   = "#ff6ac1",
  red       = "#ff5c57",
  white     = "#eff0eb",
  yellow    = "#f3f99d",
  orange    = "#ff9f43",
}

-- Built-ins
-- vim.api.nvim_set_hl(0, "Normal", {})      -- clear
vim.api.nvim_set_hl(0, "NormalFloat", {}) -- clear
vim.api.nvim_set_hl(0, "StatusLine", {})  -- clear
vim.api.nvim_set_hl(0, "WinBar", {})      -- clear
vim.api.nvim_set_hl(0, "WinBarNC", {})    -- clear

vim.api.nvim_set_hl(0, "Comment", { fg = snazzy_colors.gray, italic = true })
vim.api.nvim_set_hl(0, "Conceal", { fg = snazzy_colors.gray })
vim.api.nvim_set_hl(0, "NonText", { link = "Comment" })

vim.api.nvim_set_hl(0, "Search", { bg = snazzy_colors.yellow, fg = snazzy_colors.black })
vim.api.nvim_set_hl(0, "CurSearch", { bg = snazzy_colors.cyan, fg = snazzy_colors.black })
vim.api.nvim_set_hl(0, "IncSearch", { link = "Search" })

vim.api.nvim_set_hl(0, "Added", { fg = snazzy_colors.green })
vim.api.nvim_set_hl(0, "Changed", { bg = snazzy_colors.cyan })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = snazzy_colors.white })
vim.api.nvim_set_hl(0, "MatchParen", { fg = snazzy_colors.magenta, bold = true })
vim.api.nvim_set_hl(0, "PmenuSel", { fg = snazzy_colors.green })
vim.api.nvim_set_hl(0, "Question", { fg = snazzy_colors.cyan })
vim.api.nvim_set_hl(0, "QuickFixLine", { bg = snazzy_colors.cyan, fg = snazzy_colors.black })
vim.api.nvim_set_hl(0, "RedrawDebugClear", { bg = snazzy_colors.yellow })
vim.api.nvim_set_hl(0, "RedrawDebugComposed", { bg = snazzy_colors.green })
vim.api.nvim_set_hl(0, "RedrawDebugRecompose", { bg = snazzy_colors.red })
vim.api.nvim_set_hl(0, "Removed", { fg = snazzy_colors.red })

-- For diffview.nvim
vim.api.nvim_set_hl(0, "DiffviewFilePanelSelected", { fg = snazzy_colors.yellow })
vim.api.nvim_set_hl(0, "DiffviewStatusCopied", { fg = snazzy_colors.green })
vim.api.nvim_set_hl(0, "DiffviewStatusIgnored", { fg = snazzy_colors.gray })
vim.api.nvim_set_hl(0, "DiffviewStatusModified", { fg = snazzy_colors.yellow })
vim.api.nvim_set_hl(0, "DiffviewStatusRenamed", { fg = snazzy_colors.yellow })
vim.api.nvim_set_hl(0, "DiffviewStatusTypeChange", { fg = snazzy_colors.yellow })
vim.api.nvim_set_hl(0, "DiffviewStatusUnmerged", { fg = snazzy_colors.red })
vim.api.nvim_set_hl(0, "DiffviewStatusUntracked", { fg = snazzy_colors.gray })

vim.api.nvim_set_hl(0, "DiffviewDiffAdd", { bg = "#1d4428" })
vim.api.nvim_set_hl(0, "DiffviewDiffChange", { bg = "#542527" })
vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { bg = "#701011" })
vim.api.nvim_set_hl(0, "DiffviewDiffText", { bg = "#1e582e", bold = true })
vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { link = "DiffviewDiffDelete" })
vim.api.nvim_set_hl(0, "DiffviewDiffDeleteDim", { fg = snazzy_colors.dark_gray })

-- For fzf-lua
vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = snazzy_colors.gray })
vim.api.nvim_set_hl(0, "FzfLuaBufNr", { fg = snazzy_colors.yellow })
vim.api.nvim_set_hl(0, "FzfLuaBufName", { fg = snazzy_colors.magenta })
vim.api.nvim_set_hl(0, "FzfLuaTabMarker", { link = "FzfLuaBufNr" })
vim.api.nvim_set_hl(0, "FzfLuaHeaderBind", { link = "FzfLuaBufNr" })

-- For leap.nvim
vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Conceal" })
vim.api.nvim_set_hl(0, "LeapMatch", { fg = snazzy_colors.yellow, bold = true, nocombine = true })
vim.api.nvim_set_hl(0, "LeapLabel", { fg = snazzy_colors.magenta, bold = true, nocombine = true })

-- For nvim-cmp
vim.api.nvim_set_hl(0, "CmpDocumentation", { link = "@variable" })
vim.api.nvim_set_hl(0, "CmpDocumentationBorder", { link = "@variable" })
vim.api.nvim_set_hl(0, "CmpItemAbbr", { link = "@variable" })
vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { link = "DiagnosticDeprecated" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "Function" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "Function" })
vim.api.nvim_set_hl(0, "CmpItemKindClass", { link = "Structure" })
vim.api.nvim_set_hl(0, "CmpItemKindConstant", { link = "Constant" })
vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { link = "Structure" })
vim.api.nvim_set_hl(0, "CmpItemKindDefault", { link = "Constant" })
vim.api.nvim_set_hl(0, "CmpItemKindEnum", { link = "Type" })
vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { link = "Identifier" })
vim.api.nvim_set_hl(0, "CmpItemKindEvent", { link = "Type" })
vim.api.nvim_set_hl(0, "CmpItemKindField", { link = "Keyword" })
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { link = "Function" })
vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "Type" })
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { link = "Keyword" })
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "Function" })
vim.api.nvim_set_hl(0, "CmpItemKindModule", { link = "Structure" })
vim.api.nvim_set_hl(0, "CmpItemKindOperator", { link = "Keyword" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "Identifier" })
vim.api.nvim_set_hl(0, "CmpItemKindReference", { link = "Special" })
vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { link = "Type" })
vim.api.nvim_set_hl(0, "CmpItemKindStruct", { link = "Structure" })
vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { link = "Type" })
vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "Special" })
vim.api.nvim_set_hl(0, "CmpItemKindValue", { link = "Special" })
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { link = "Special" })
vim.api.nvim_set_hl(0, "CmpItemMenu", { link = "Conceal" })

-- For nvim-foldsign
vim.api.nvim_set_hl(0, "FoldColumn", { link = "Conceal" })

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
vim.api.nvim_set_hl(0, "NavicSeparator", { link = "Conceal" })
vim.api.nvim_set_hl(0, "NavicText", { link = "@variable" })

-- For nvim-ufo
vim.api.nvim_set_hl(0, "Folded", { bg = snazzy_colors.dark_gray, italic = true })
vim.api.nvim_set_hl(0, "UfoFoldedBg", { bg = snazzy_colors.dark_gray })
vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { fg = snazzy_colors.yellow, bold = true })

-- LSP highlights
vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })

vim.api.nvim_set_hl(0, "DiagnosticError", { fg = snazzy_colors.red })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = snazzy_colors.blue })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = snazzy_colors.cyan })
vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = snazzy_colors.green })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = snazzy_colors.yellow })

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = snazzy_colors.red, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = snazzy_colors.blue, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = snazzy_colors.cyan, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineOk", { sp = snazzy_colors.green, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = snazzy_colors.yellow, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticDeprecated", { fg = snazzy_colors.gray, strikethrough = true })

-- Semantic highlights - python
vim.api.nvim_set_hl(0, "@lsp.mod.builtin.python", { link = "@constant.builtin" })
vim.api.nvim_set_hl(0, "@lsp.mod.defaultLibrary.python", { link = "@constant.builtin" })
vim.api.nvim_set_hl(0, "@lsp.mod.readonly.python", { link = "@constant.python" })
vim.api.nvim_set_hl(0, "@lsp.type.variable.python", { link = "@variable" })
vim.api.nvim_set_hl(0, "@lsp.typemod.class.defaultLibrary.python", { link = "@constant.builtin" })
vim.api.nvim_set_hl(0, "@lsp.typemod.function.defaultLibrary.python", { link = "@constant.builtin" })
vim.api.nvim_set_hl(0, "@lsp.typemod.namespace.defaultLibrary.python", { link = "Structure" })
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.readonly.python", { link = "@constant.python" })

-- Semantic highlights - typescript/javascript
vim.api.nvim_set_hl(0, "@lsp.mod.readonly.typescriptreact", { link = "@constant.typescript" })
vim.api.nvim_set_hl(0, "@lsp.typemod.parameter.declaration.typescriptreact", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.readonly.typescript", { link = "@constant.typescript" })
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.readonly.typescriptreact", { link = "@constant.typescript" })
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.defaultLibrary.typescript", { link = "@type.builtin.typescript" })

-- Semantic highlights - java & scala
vim.api.nvim_set_hl(0, "@lsp.type.modifier.java", { link = "Keyword" })
vim.api.nvim_set_hl(0, "@lsp.typemod.property.readonly.java", { link = "Constant" })
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.readonly.scala", { link = "Constant" })

-- Semantic highlights - lua
vim.api.nvim_set_hl(0, "@lsp.typemod.function.defaultLibrary.lua", { link = "Special" })

return {
  snazzy_colors = snazzy_colors,
}
