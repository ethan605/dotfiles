local opts = { noremap = true, silent = true }

-- Move to previous/next buffer
vim.api.nvim_set_keymap("n", "g[", ":BufferLineCyclePrev<CR>", opts)
vim.api.nvim_set_keymap("n", "g]", ":BufferLineCycleNext<CR>", opts)

-- Re-order to previous/next buffer
vim.api.nvim_set_keymap("n", "g{", ":BufferLineMovePrev<CR>", opts)
vim.api.nvim_set_keymap("n", "g}", ":BufferLineMoveNext<CR>", opts)

-- Manipulate buffers
vim.api.nvim_set_keymap("n", "gC", ":bdelete!<CR>", opts)
vim.api.nvim_set_keymap("n", "gq", ":BufferLinePickClose<CR>", opts)
vim.api.nvim_set_keymap("n", "gs", ":BufferLinePick<CR>", opts)

-- Move to previous/next tab
vim.api.nvim_set_keymap("n", "t[", ":tabprevious<CR>", opts)
vim.api.nvim_set_keymap("n", "t]", ":tabnext<CR>", opts)
