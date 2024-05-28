local opts = { noremap = true, silent = true }

-- Leader as Easymotion prefix
vim.api.nvim_set_keymap("n", "<Leader>", "<Plug>(easymotion-prefix)", { silent = true })

-- NvimTree
vim.api.nvim_set_keymap("n", "<C-o>", ":NvimTreeToggle<CR>", opts)

-- Utilities from fzf-lua
vim.api.nvim_set_keymap("n", "gb", ":FzfLua buffers<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-f>", ":FzfLua files<CR>", opts)
vim.api.nvim_set_keymap(
  "n",
  "<C-g>",
  ":lua require('fzf-lua').git_files({ cmd = 'git ls-files --modified' })<CR>",
  opts
)
vim.api.nvim_set_keymap("n", "<C-m>", ":FzfLua commands<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-p>", ":FzfLua git_files<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-s>", ":FzfLua grep<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-s>", ":FzfLua grep_visual<CR>", opts)

-- Leader + Space to hide search highlights
vim.api.nvim_set_keymap("n", "<Leader><Space>", ":nohlsearch<CR>", opts)

vim.api.nvim_set_keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
vim.api.nvim_set_keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- Gitsigns
vim.api.nvim_set_keymap("n", "[c", "<cmd>Gitsigns prev_hunk<CR>", opts)
vim.api.nvim_set_keymap("n", "]c", "<cmd>Gitsigns next_hunk<CR>", opts)

-- Misc
vim.api.nvim_set_keymap("n", "gc", ":close<CR>", opts)

-- python.vim
-- "[[" Jump backwards to begin of current/previous toplevel
-- "[]" Jump backwards to end of previous toplevel
-- "][" Jump forwards to end of current toplevel
-- "]]" Jump forwards to begin of next toplevel
-- "[m" Jump backwards to begin of current/previous method/scope
-- "[M" Jump backwards to end of previous method/scope
-- "]M" Jump forwards to end of current/next method/scope
-- "]m" Jump forwards to begin of next method/scope

require("keymaps.bufferline")
require("keymaps.nvim-dap")
