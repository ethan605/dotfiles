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

-- Call Stylua on save - using none-ls
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.luau" },
  command = "lua vim.lsp.buf.format()",
  group = autoFormatGroup,
})

-- Call clang-format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.h", "*.hpp", "*.c", "*.cc", "*.cpp" },
  command = "ClangFormat",
  group = autoFormatGroup,
})

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("help_window_right", {}),
  pattern = { "*.txt" },
  callback = function()
    if vim.o.filetype == "help" then
      vim.cmd.wincmd("L")
    end
  end,
})
