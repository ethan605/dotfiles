-- Performance tweaks for large files
local jsSyntaxGroup = vim.api.nvim_create_augroup("JsSyntaxGroup", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*js", "*.jsx", "*.ts", "*.tsx" },
  command = "syntax sync fromstart",
  group = jsSyntaxGroup,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = { "*js", "*.jsx", "*.ts", "*.tsx" },
  command = "syntax sync clear",
  group = jsSyntaxGroup,
})

-- Auto format
local autoFormatGroup = vim.api.nvim_create_augroup("AutoFormatGroup", { clear = true })

-- Use prettier-stylelint for CSS
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*.css", "*.scss" },
  command = "let b:prettier_exec_cmd = 'prettier-stylelint'",
  group = autoFormatGroup,
})

--[[
-- Call Prettier on save - can be slow for big sources (> 3k lines)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.css", "*.scss", "*.less", "*.graphql" },
  command = "PrettierAsync",
  group = autoFormatGroup,
})
]]

-- Call Stylua on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua" },
  command = "lua require('stylua').format()",
  group = autoFormatGroup,
})

-- Call clang-format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.h", "*.hpp", "*.c", "*.cc", "*.cpp" },
  command = "ClangFormat",
  group = autoFormatGroup,
})
