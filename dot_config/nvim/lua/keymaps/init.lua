local opts = { noremap = true, silent = true }

-- Moving visual blocks
vim.api.nvim_set_keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
vim.api.nvim_set_keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- Hide search highlights
vim.api.nvim_set_keymap("n", "<leader><space>", ":nohlsearch<CR>", opts)

-- For leap.nvim
vim.keymap.set({ "n", "x", "o" }, "<leader>s", "<Plug>(leap-forward)")
vim.keymap.set({ "n", "x", "o" }, "<leader>S", "<Plug>(leap-backward)")

-- For gitsigns.nvim
vim.api.nvim_set_keymap("n", "[c", ":Gitsigns prev_hunk<CR>", opts)
vim.api.nvim_set_keymap("n", "]c", ":Gitsigns next_hunk<CR>", opts)

-- For nvim-tree
vim.api.nvim_set_keymap("n", "<C-o>", ":NvimTreeToggle<CR>", opts)

-- For nvim-ufo
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- For vista.vim
vim.api.nvim_set_keymap("n", "<leader>v", ":Vista finder<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>V", ":Vista!!<CR>", opts)

---@diagnostic disable: different-requires
require("keymaps.bufferline")
require("keymaps.fzf-lua")
require("keymaps.nvim-dap")
---@diagnostic enable: different-requires
