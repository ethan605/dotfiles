vim.cmd [[filetype plugin on]]
vim.cmd [[syntax on]]
vim.cmd [[set termguicolors]]
vim.cmd [[colorscheme snazzy]]

-- Line limit column colors
vim.cmd [[hi ColorColumn  guibg=gray  guifg=fg]]

-- TabLine highlight colors
vim.cmd [[hi TabLine      gui=none          guibg=bg  guifg=white]]
vim.cmd [[hi TabLineFill  gui=none          guibg=bg]]
vim.cmd [[hi TabLineSel   gui=bold,inverse]]

-- Matched parentheses colors
vim.cmd [[hi MatchParen   gui=bold  guibg=none  guifg=#ff6ac1]]

-- Show a mark for characters at column 120
vim.cmd [[call matchadd("ColorColumn", "\%120v", 120)]]
