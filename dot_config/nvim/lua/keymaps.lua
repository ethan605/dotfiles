-- Smarter NERDTree toggle
local default_keymap_opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap(
  "n",
  "<C-o>",
  ":lua if vim.bo.filetype == 'nerdtree' then vim.cmd [[ :NERDTreeToggle ]] else vim.cmd [[ :NERDTreeFind ]] end<cr>",
  default_keymap_opts
)

-- Copy current file's path
vim.api.nvim_set_keymap("n", "ycf", ":let @+=@%<cr>", default_keymap_opts)

-- Quick files opening
vim.api.nvim_set_keymap("n", "<C-p>", ":GFiles<cr>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<C-g>", ":GFiles?<cr>", default_keymap_opts)

-- Leader + space to hide search highlights
vim.api.nvim_set_keymap("n", "<leader><space>", ":nohlsearch<cr>", default_keymap_opts)

-- Leader as Easymotion prefix
vim.api.nvim_set_keymap("n", "<leader>", "<Plug>(easymotion-prefix)", { silent = true })

-- Search globally with RipGrep
vim.api.nvim_set_keymap("n", "<C-s>", ":Rg<space>", { noremap = true })

-- Move to previous/next tab
vim.api.nvim_set_keymap("n", "<A-,>", ":BufferPrevious<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A-.>", ":BufferNext<CR>", default_keymap_opts)

-- Re-order to previous/next tab
vim.api.nvim_set_keymap("n", "<A-<>", ":BufferMovePrevious<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A->>", ":BufferMoveNext<CR>", default_keymap_opts)

-- Goto tab in position
vim.api.nvim_set_keymap("n", "<A-1>", ":BufferGoto 1<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A-2>", ":BufferGoto 2<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A-3>", ":BufferGoto 3<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A-4>", ":BufferGoto 4<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A-5>", ":BufferGoto 5<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A-6>", ":BufferGoto 6<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A-7>", ":BufferGoto 7<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A-8>", ":BufferGoto 8<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A-9>", ":BufferGoto 9<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A-0>", ":BufferLast<CR>", default_keymap_opts)

-- Manipulate tabs
vim.api.nvim_set_keymap("n", "<A-c>", ":BufferClose<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<A-s>", ":BufferPick<CR>", default_keymap_opts)
