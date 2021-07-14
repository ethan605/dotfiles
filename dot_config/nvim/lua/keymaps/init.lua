local default_opts = { noremap = true, silent = true }

-- Smarter NERDTree toggle
vim.api.nvim_set_keymap(
  "n",
  "<C-o>",
  ":if &filetype == 'nerdtree' | NERDTreeToggle | else | NERDTreeFind | endif<cr>",
  default_opts
)

-- Smarter NvimTree toggle
-- vim.api.nvim_set_keymap(
  -- "n",
  -- "<C-o>",
  -- ":if &filetype == 'NvimTree' | NvimTreeToggle | else NvimTreeFindFile | endif<cr>",
  -- default_opts
-- )

-- Quick files opening
vim.api.nvim_set_keymap("n", "<C-p>", ":GFiles<cr>", default_opts)
vim.api.nvim_set_keymap("n", "<C-g>", ":GFiles?<cr>", default_opts)

-- Leader + Space to hide search highlights
vim.api.nvim_set_keymap("n", "<Leader><Space>", ":nohlsearch<cr>", default_opts)

-- Leader + v to toggle Vista
vim.api.nvim_set_keymap("n", "<Leader>v", ":Vista!!<cr>", default_opts)

-- Leader as Easymotion prefix
vim.api.nvim_set_keymap("n", "<Leader>", "<Plug>(easymotion-prefix)", { silent = true })

-- Search globally with RipGrep
vim.api.nvim_set_keymap("n", "<C-s>", ":Rg<Space>", { noremap = true })

require("keymaps.barbar")
require("keymaps.compe")
