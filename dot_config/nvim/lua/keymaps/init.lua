local opts = { noremap = true, silent = true }

-- Leader as Easymotion prefix
vim.api.nvim_set_keymap("n", "<Leader>", "<Plug>(easymotion-prefix)", { silent = true })

vim.api.nvim_set_keymap("n", "<C-o>", ":NvimTreeToggle<CR>", opts)

-- Utilities from fzf.nvim
vim.api.nvim_set_keymap("n", "<C-f>", ":FzfFiles<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-g>", ":FzfGFiles?<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-m>", ":FzfCommands<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-p>", ":FzfGFiles<CR>", opts)

-- Search globally with RipGrep
vim.api.nvim_set_keymap("n", "<C-s>", ":FzfRg<Space>", { noremap = true })

-- Leader + Space to hide search highlights
vim.api.nvim_set_keymap("n", "<Leader><Space>", ":nohlsearch<CR>", opts)

-- Leader + v to toggle Vista finder
vim.api.nvim_set_keymap("n", "<Leader>v", ":Vista finder<CR>", opts)
-- Leader + Leader + v to toggle Vista finder
vim.api.nvim_set_keymap("n", "<Leader><Leader>v", ":Vista!!<CR>", opts)

vim.api.nvim_set_keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
vim.api.nvim_set_keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- Gitsigns
vim.api.nvim_set_keymap("n", "[c", "<cmd>Gitsigns prev_hunk<CR>", opts)
vim.api.nvim_set_keymap("n", "]c", "<cmd>Gitsigns next_hunk<CR>", opts)

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
require("keymaps.compe")
require("keymaps.nvim-dap")
