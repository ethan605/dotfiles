local default_opts = { noremap = true, silent = true }

-- Leader as Easymotion prefix
vim.api.nvim_set_keymap("n", "<Leader>", "<Plug>(easymotion-prefix)", { silent = true })

vim.api.nvim_set_keymap("n", "<C-o>", ":NvimTreeToggle<CR>", default_opts)

-- Open files with FZF
vim.api.nvim_set_keymap("n", "<C-b>", ":Buffers<CR>", default_opts)
vim.api.nvim_set_keymap("n", "<C-f>", ":Files<CR>", default_opts)
vim.api.nvim_set_keymap("n", "<C-g>", ":GFiles?<CR>", default_opts)
vim.api.nvim_set_keymap("n", "<C-m>", ":Commands<CR>", default_opts)
vim.api.nvim_set_keymap("n", "<C-p>", ":GFiles<CR>", default_opts)

-- Search globally with RipGrep
vim.api.nvim_set_keymap("n", "<C-s>", ":Rg<Space>", { noremap = true })

-- Leader + Space to hide search highlights
vim.api.nvim_set_keymap("n", "<Leader><Space>", ":nohlsearch<CR>", default_opts)

-- Leader + v to toggle Vista
vim.api.nvim_set_keymap("n", "<Leader>v", ":Vista!!<CR>", default_opts)

vim.api.nvim_set_keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", default_opts)
vim.api.nvim_set_keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", default_opts)

-- Gitsigns
vim.api.nvim_set_keymap("n", "[c", "<cmd>Gitsigns prev_hunk<CR>", default_opts)
vim.api.nvim_set_keymap("n", "]c", "<cmd>Gitsigns next_hunk<CR>", default_opts)

--require("keymaps.barbar")
require("keymaps.bufferline")
require("keymaps.compe")
