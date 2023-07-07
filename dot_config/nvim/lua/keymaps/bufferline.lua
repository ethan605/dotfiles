local default_opts = { noremap = true, silent = true }

-- Move to previous/next buffer
vim.api.nvim_set_keymap("n", "g[", ":BufferLineCyclePrev<CR>", default_opts)
vim.api.nvim_set_keymap("n", "g]", ":BufferLineCycleNext<CR>", default_opts)

-- Re-order to previous/next buffer
vim.api.nvim_set_keymap("n", "g{", ":BufferLineMovePrev<CR>", default_opts)
vim.api.nvim_set_keymap("n", "g}", ":BufferLineMoveNext<CR>", default_opts)

-- Manipulate buffers
vim.api.nvim_set_keymap("n", "gc", ":bdelete!<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gq", ":BufferLinePickClose<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gs", ":Buffers<CR>", default_opts)

-- Move to previous/next tab
vim.api.nvim_set_keymap("n", "t[", ":tabprevious<CR>", default_opts)
vim.api.nvim_set_keymap("n", "t]", ":tabnext<CR>", default_opts)
