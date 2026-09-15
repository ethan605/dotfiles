local snazzy_colors = {
  -- Base colors
  black     = "#282a36",
  blue      = "#57c7ff",
  cyan      = "#9aedfe",
  green     = "#5af78e",
  magenta   = "#ff6ac1",
  red       = "#ff5c57",
  white     = "#eff0eb",
  yellow    = "#f3f99d",
  -- Colors from base16-snazzy
  dark_gray = "#34353e", -- base01
  gray      = "#78787e", -- base03
  orange    = "#ff9f43", -- base07
}

-- Built-ins
vim.api.nvim_set_hl(0, "Normal", {})      -- clear
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

-- Delta / GitHub diff palette. Consumed by the per-side winhighlight hook in lua/plugins/diffview.lua
vim.api.nvim_set_hl(0, "DeltaDiffMinus", { bg = "#3f0001" })                -- removed line base
vim.api.nvim_set_hl(0, "DeltaDiffMinusEmph", { bg = "#901011" })            -- removed changed span
vim.api.nvim_set_hl(0, "DeltaDiffPlus", { bg = "#002800" })                 -- added line base
vim.api.nvim_set_hl(0, "DeltaDiffPlusEmph", { bg = "#006000" })             -- added changed span
vim.api.nvim_set_hl(0, "DeltaDiffFiller", { fg = snazzy_colors.dark_gray }) -- missing-counterpart filler

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

-- For blink.cmp
vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "@variable" })
vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "@variable" })
vim.api.nvim_set_hl(0, "BlinkCmpKind", { link = "Constant" })
vim.api.nvim_set_hl(0, "BlinkCmpLabel", { link = "@variable" })
vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { link = "DiagnosticDeprecated" })
vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { link = "Function" })
vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "@variable" })
vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "@variable" })
vim.api.nvim_set_hl(0, "BlinkCmpSource", { link = "Conceal" })

-- Per-kind icons: mirrors the previous lspkind/CmpItemKind palette
local blink_kind_links = {
  Class = "Structure",
  Constant = "Constant",
  Constructor = "Structure",
  Enum = "Type",
  EnumMember = "Identifier",
  Event = "Type",
  Field = "Keyword",
  Function = "Function",
  Interface = "Type",
  Keyword = "Keyword",
  Method = "Function",
  Module = "Structure",
  Operator = "Keyword",
  Property = "Identifier",
  Reference = "Special",
  Snippet = "Type",
  Struct = "Structure",
  TypeParameter = "Type",
  Unit = "Special",
  Value = "Special",
  Variable = "Special",
}
for kind, link in pairs(blink_kind_links) do
  vim.api.nvim_set_hl(0, "BlinkCmpKind" .. kind, { link = link })
end

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

-- Semantic highlights - devicetree
vim.api.nvim_set_hl(0, "@lsp.type.type.dts", { link = "Structure" })

return {
  snazzy_colors = snazzy_colors,
}
