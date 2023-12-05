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

-- Call Prettier on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.css", "*.scss", "*.less", "*.graphql" },
  command = "Prettier",
  group = autoFormatGroup,
})

-- Call Stylua on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua" },
  command = "lua require('stylua').format()",
  group = autoFormatGroup,
})

-- Force syntax highlight for specific file types
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = ".prettierrc",
  command = "set syntax=json",
})

-- Not sure why Python files always have colorcolumn="120,+1"
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.py",
  command = "set colorcolumn=120",
})

-- Update lightbulb on cursor move
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "lua require('nvim-lightbulb').update_lightbulb()",
})
