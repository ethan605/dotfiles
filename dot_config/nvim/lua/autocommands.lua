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
