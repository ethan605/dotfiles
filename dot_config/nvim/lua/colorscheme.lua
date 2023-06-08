vim.cmd [[
  filetype plugin on
  colorscheme snazzy
]]

vim.opt.termguicolors = true

-- Line limit column colors
vim.api.nvim_set_hl(0, "ColorColumn", { bg="gray" })

-- Matched parentheses colors
vim.api.nvim_set_hl(0, "MatchParen", { bold=true, fg="#ff6ac1" })

-- Show a mark for characters at column 120
vim.cmd [[ call matchadd("ColorColumn", "\%120v", 120) ]]
