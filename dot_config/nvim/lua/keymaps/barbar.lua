local default_opts = { noremap = true, silent = true }

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
