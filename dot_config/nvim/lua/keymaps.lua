local noremap_silent = { noremap = true, silent = true }
local noremap_expr = { noremap = true, silent = true, expr = true }

-- Smarter NvimTree toggle
vim.api.nvim_set_keymap(
  "n",
  "<C-o>",
  ":lua if vim.bo.filetype == 'NvimTree' then vim.cmd [[ :NvimTreeToggle ]] else vim.cmd [[ :NvimTreeFindFile ]] end<cr>",
  noremap_silent
)

-- Quick files opening
vim.api.nvim_set_keymap("n", "<C-p>", ":GFiles<cr>", noremap_silent)
vim.api.nvim_set_keymap("n", "<C-g>", ":GFiles?<cr>", noremap_silent)

-- Leader + space to hide search highlights
vim.api.nvim_set_keymap("n", "<leader><space>", ":nohlsearch<cr>", noremap_silent)

-- Leader as Easymotion prefix
vim.api.nvim_set_keymap("n", "<leader>", "<Plug>(easymotion-prefix)", { silent = true })

-- Search globally with RipGrep
vim.api.nvim_set_keymap("n", "<C-s>", ":Rg<space>", { noremap = true })

-- Move to previous/next tab
vim.api.nvim_set_keymap("n", "g[", ":BufferPrevious<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "g]", ":BufferNext<CR>", noremap_silent)

-- Re-order to previous/next tab
vim.api.nvim_set_keymap("n", "g{", ":BufferMovePrevious<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "g}", ":BufferMoveNext<CR>", noremap_silent)

-- Goto tab in position
vim.api.nvim_set_keymap("n", "gt1", ":BufferGoto 1<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "gt2", ":BufferGoto 2<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "gt3", ":BufferGoto 3<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "gt4", ":BufferGoto 4<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "gt5", ":BufferGoto 5<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "gt6", ":BufferGoto 6<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "gt7", ":BufferGoto 7<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "gt8", ":BufferGoto 8<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "gt9", ":BufferGoto 9<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "gt0", ":BufferLast<CR>", noremap_silent)

-- Manipulate tabs
vim.api.nvim_set_keymap("n", "gc", ":BufferClose<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "gs", ":BufferPick<CR>", noremap_silent)

-- Lspsaga
vim.api.nvim_set_keymap("n", "gh", ":Lspsaga lsp_finder<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "ca", ":Lspsaga code_action<CR>", noremap_silent)
vim.api.nvim_set_keymap("v", "ca", ":<C-U>Lspsaga range_code_action<CR>", noremap_silent)
vim.api.nvim_set_keymap("n", "K", ":Lspsaga hover_doc<CR>", noremap_silent)

-- Compe
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", noremap_expr)
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", noremap_expr)
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", noremap_expr)
vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 })", noremap_expr)
vim.api.nvim_set_keymap("i", "<C-d>", "compe#scroll({ 'delta': -4 })", noremap_expr)
