local opts = { noremap = true, silent = true }

-- Move to previous/next buffer
vim.keymap.set("n", "g[", ":BufferLineCyclePrev<CR>", opts)
vim.keymap.set("n", "g]", ":BufferLineCycleNext<CR>", opts)

-- Re-order to previous/next buffer
vim.keymap.set("n", "g{", ":BufferLineMovePrev<CR>", opts)
vim.keymap.set("n", "g}", ":BufferLineMoveNext<CR>", opts)

-- Manipulate buffers
vim.keymap.set("n", "gC", ":bdelete!<CR>", opts)
vim.keymap.set("n", "gq", ":BufferLinePickClose<CR>", opts)
vim.keymap.set("n", "gs", ":BufferLinePick<CR>", opts)

-- Move to previous/next tab
vim.keymap.set("n", "t[", ":tabprevious<CR>", opts)
vim.keymap.set("n", "t]", ":tabnext<CR>", opts)

-- Close tab
vim.keymap.set("n", "gc", ":close<CR>", opts)
