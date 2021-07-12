local default_keymap_opts = { noremap = true, silent = true }

-- Smarter NvimTree toggle
vim.api.nvim_set_keymap(
  "n",
  "<C-o>",
  ":lua if vim.bo.filetype == 'NvimTree' then vim.cmd [[ :NvimTreeToggle ]] else vim.cmd [[ :NvimTreeFindFile ]] end<cr>",
  default_keymap_opts
)

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
vim.api.nvim_set_keymap("n", "g[", ":BufferPrevious<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "g]", ":BufferNext<CR>", default_keymap_opts)

-- Re-order to previous/next tab
vim.api.nvim_set_keymap("n", "g{", ":BufferMovePrevious<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "g}", ":BufferMoveNext<CR>", default_keymap_opts)

-- Goto tab in position
vim.api.nvim_set_keymap("n", "gt1", ":BufferGoto 1<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "gt2", ":BufferGoto 2<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "gt3", ":BufferGoto 3<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "gt4", ":BufferGoto 4<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "gt5", ":BufferGoto 5<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "gt6", ":BufferGoto 6<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "gt7", ":BufferGoto 7<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "gt8", ":BufferGoto 8<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "gt9", ":BufferGoto 9<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "gt0", ":BufferLast<CR>", default_keymap_opts)

-- Manipulate tabs
vim.api.nvim_set_keymap("n", "gc", ":BufferClose<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "gs", ":BufferPick<CR>", default_keymap_opts)

-- Lspsaga
vim.api.nvim_set_keymap("n", "gh", ":Lspsaga lsp_finder<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "ca", ":Lspsaga code_action<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("v", "ca", ":<C-U>Lspsaga range_code_action<CR>", default_keymap_opts)
vim.api.nvim_set_keymap("n", "K", ":Lspsaga hover_doc<CR>", default_keymap_opts)
