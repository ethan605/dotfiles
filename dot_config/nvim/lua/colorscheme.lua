vim.cmd [[
  filetype plugin on
  colorscheme snazzy
]]

vim.opt.termguicolors = true

-- Line limit column colors
vim.api.nvim_set_hl(0, "ColorColumn", { bg="#606060" })

-- Matched parentheses colors
vim.api.nvim_set_hl(0, "MatchParen", { bold=true, fg="#ff6ac1" })
