local default_opts = { noremap = true, silent = true }

-- Leader as Easymotion prefix
vim.api.nvim_set_keymap("n", "<Leader>", "<Plug>(easymotion-prefix)", { silent = true })

vim.api.nvim_set_keymap("n", "<C-o>", ":NvimTreeToggle<CR>", default_opts)

-- Utilities from fzf.nvim
vim.api.nvim_set_keymap("n", "<C-f>", ":FzfFiles<CR>", default_opts)
vim.api.nvim_set_keymap("n", "<C-g>", ":FzfGFiles?<CR>", default_opts)
vim.api.nvim_set_keymap("n", "<C-m>", ":FzfCommands<CR>", default_opts)
vim.api.nvim_set_keymap("n", "<C-p>", ":FzfGFiles<CR>", default_opts)

-- Search globally with RipGrep
vim.api.nvim_set_keymap("n", "<C-s>", ":Rg<Space>", { noremap = true })

-- Leader + Space to hide search highlights
vim.api.nvim_set_keymap("n", "<Leader><Space>", ":nohlsearch<CR>", default_opts)

-- Leader + v to toggle Vista finder
vim.api.nvim_set_keymap("n", "<Leader>v", ":Vista finder<CR>", default_opts)
-- Leader + Leader + v to toggle Vista finder
vim.api.nvim_set_keymap("n", "<Leader><Leader>v", ":Vista!!<CR>", default_opts)

vim.api.nvim_set_keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", default_opts)
vim.api.nvim_set_keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", default_opts)

-- Gitsigns
vim.api.nvim_set_keymap("n", "[c", "<cmd>Gitsigns prev_hunk<CR>", default_opts)
vim.api.nvim_set_keymap("n", "]c", "<cmd>Gitsigns next_hunk<CR>", default_opts)

require("keymaps.bufferline")
require("keymaps.compe")
