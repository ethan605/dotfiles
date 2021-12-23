-- Performance tweaks for large files
vim.cmd [[
  autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
  autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
]]

-- Disable unnecessary conceals for markdowns
vim.cmd [[
  augroup markdown_concealing
    autocmd!
    autocmd FileType markdown let g:indentLine_enabled=0
    autocmd FileType markdown set conceallevel=0
  augroup END
]]

-- Force syntax highlight for specific file types
vim.cmd [[
  autocmd BufNewFile,BufRead .prettierrc set syntax=json
]]

-- Call Flake8 on write for Python files
vim.cmd [[ autocmd BufWritePost *.py call flake8#Flake8() ]]

-- Autoformat with Prettier on save
vim.cmd [[
  autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.json,*.css,*.scss,*.less,*.graphql Prettier
]]

-- Use prettier-stylelint for CSS
vim.cmd [[ autocmd FileType css,scss let b:prettier_exec_cmd = "prettier-stylelint" ]]

-- Update lightbulb on cursor move
vim.cmd [[ autocmd CursorHold,CursorHoldI * lua require("nvim-lightbulb").update_lightbulb() ]]
