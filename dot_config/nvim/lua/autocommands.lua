-- Performance tweaks for large files
local jsSyntaxSync = vim.api.nvim_create_augroup("JsSyntaxSync", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*js", "*.jsx", "*.ts", "*.tsx" },
  command = ":syntax sync fromstart",
  group = jsSyntaxSync,
})
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = { "*js", "*.jsx", "*.ts", "*.tsx" },
  command = ":syntax sync clear",
  group = jsSyntaxSync,
})

-- Force syntax highlight for specific file types
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = ".prettierrc",
  command = "set syntax=json",
})

-- Call Flake8 on write for Python files
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.py" },
  command = "call flake8#Flake8()",
})

-- Autoformat with Prettier on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.css", "*.scss", "*.less", "*.graphql" },
  command = "Prettier",
})

-- Use prettier-stylelint for CSS
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "css", "scss" },
  command = "let b:prettier_exec_cmd = 'prettier-stylelint'",
})

-- Update lightbulb on cursor move
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "lua require('nvim-lightbulb').update_lightbulb()",
})
