local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, silent = true, expr = true }

-- Smarter NERDTree toggle
vim.api.nvim_set_keymap(
  "n",
  "<C-o>",
  ":if &filetype == 'nerdtree' | NERDTreeToggle | else | NERDTreeFind | endif<cr>",
  default_opts
)

-- Smarter NvimTree toggle
--vim.api.nvim_set_keymap(
  --"n",
  --"<C-o>",
  --":if &filetype == 'NvimTree' | NvimTreeToggle | else NvimTreeFindFile | endif<cr>",
  --default_opts
--)

-- Quick files opening
vim.api.nvim_set_keymap("n", "<C-p>", ":GFiles<cr>", default_opts)
vim.api.nvim_set_keymap("n", "<C-g>", ":GFiles?<cr>", default_opts)

-- Leader + space to hide search highlights
vim.api.nvim_set_keymap("n", "<leader><space>", ":nohlsearch<cr>", default_opts)

-- Leader as Easymotion prefix
vim.api.nvim_set_keymap("n", "<leader>", "<Plug>(easymotion-prefix)", { silent = true })

-- Search globally with RipGrep
vim.api.nvim_set_keymap("n", "<C-s>", ":Rg<space>", { noremap = true })

-- Move to previous/next tab
vim.api.nvim_set_keymap("n", "g[", ":BufferPrevious<CR>", default_opts)
vim.api.nvim_set_keymap("n", "g]", ":BufferNext<CR>", default_opts)

-- Re-order to previous/next tab
vim.api.nvim_set_keymap("n", "g{", ":BufferMovePrevious<CR>", default_opts)
vim.api.nvim_set_keymap("n", "g}", ":BufferMoveNext<CR>", default_opts)

-- Goto tab in position
vim.api.nvim_set_keymap("n", "gt1", ":BufferGoto 1<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt2", ":BufferGoto 2<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt3", ":BufferGoto 3<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt4", ":BufferGoto 4<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt5", ":BufferGoto 5<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt6", ":BufferGoto 6<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt7", ":BufferGoto 7<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt8", ":BufferGoto 8<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt9", ":BufferGoto 9<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt0", ":BufferLast<CR>", default_opts)

-- Manipulate tabs
vim.api.nvim_set_keymap("n", "gc", ":BufferClose<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gs", ":BufferPick<CR>", default_opts)

-- Lspsaga
vim.api.nvim_set_keymap("n", "gh", ":Lspsaga lsp_finder<CR>", default_opts)
vim.api.nvim_set_keymap("n", "ca", ":Lspsaga code_action<CR>", default_opts)
vim.api.nvim_set_keymap("v", "ca", ":<C-U>Lspsaga range_code_action<CR>", default_opts)
vim.api.nvim_set_keymap("n", "K", ":Lspsaga hover_doc<CR>", default_opts)

-- Compe
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", expr_opts)
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", expr_opts)
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", expr_opts)
vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 })", expr_opts)
vim.api.nvim_set_keymap("i", "<C-d>", "compe#scroll({ 'delta': -4 })", expr_opts)
