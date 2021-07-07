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
vim.api.nvim_set_keymap("n", "<c-p>", ":GFiles<cr>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "<c-g>", ":GFiles?<cr>", default_keymap_opts)

-- Leader + space to hide search highlights
vim.api.nvim_set_keymap("n", "<leader><space>", ":nohlsearch<cr>", default_keymap_opts)

-- Leader as Easymotion prefix
vim.api.nvim_set_keymap("n", "<leader>", "<Plug>(easymotion-prefix)", { silent = true })

-- Search globally with RipGrep
vim.api.nvim_set_keymap("n", "<c-s>", ":Rg<space>", { noremap = true })
