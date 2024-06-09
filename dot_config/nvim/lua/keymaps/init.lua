local opts = { noremap = true, silent = true }

-- <leader> as easymotion prefix
vim.api.nvim_set_keymap("n", "<leader>", "<Plug>(easymotion-prefix)", { silent = true })

-- Moving visual blocks
vim.api.nvim_set_keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
vim.api.nvim_set_keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- Hide search highlights
vim.api.nvim_set_keymap("n", "<leader><space>", ":nohlsearch<CR>", opts)

-- For dropbar.nvim
vim.api.nvim_set_keymap("n", "<space>k", ":lua require('dropbar.api').pick()<CR>", opts)

-- For gitsigns.nvim
vim.api.nvim_set_keymap("n", "[c", ":Gitsigns prev_hunk<CR>", opts)
vim.api.nvim_set_keymap("n", "]c", ":Gitsigns next_hunk<CR>", opts)

-- For nvim-tree
vim.api.nvim_set_keymap("n", "<C-o>", ":NvimTreeToggle<CR>", opts)

-- For vista.vim
vim.api.nvim_set_keymap("n", "<leader>v", ":Vista finder<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>V", ":Vista!!<CR>", opts)

---@diagnostic disable: different-requires
require("keymaps.bufferline")
require("keymaps.fzf-lua")
require("keymaps.nvim-dap")
---@diagnostic enable: different-requires
