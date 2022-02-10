local default_opts = { noremap = true, silent = true }

-- Move to previous/next tab
vim.api.nvim_set_keymap("n", "g[", ":BufferLineCyclePrev<CR>", default_opts)
vim.api.nvim_set_keymap("n", "g]", ":BufferLineCycleNext<CR>", default_opts)

-- Re-order to previous/next tab
vim.api.nvim_set_keymap("n", "g{", ":BufferLineMovePrev<CR>", default_opts)
vim.api.nvim_set_keymap("n", "g}", ":BufferLineMoveNext<CR>", default_opts)

-- Goto tab in position
vim.api.nvim_set_keymap("n", "gt1", ":BufferLineGoToBuffer 1<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt2", ":BufferLineGoToBuffer 2<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt3", ":BufferLineGoToBuffer 3<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt4", ":BufferLineGoToBuffer 4<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt5", ":BufferLineGoToBuffer 5<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt6", ":BufferLineGoToBuffer 6<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt7", ":BufferLineGoToBuffer 7<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt8", ":BufferLineGoToBuffer 8<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gt9", ":BufferLineGoToBuffer 9<CR>", default_opts)

-- Manipulate tabs
vim.api.nvim_set_keymap("n", "gc", ":bdelete!<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gq", ":BufferLinePickClose<CR>", default_opts)
vim.api.nvim_set_keymap("n", "gs", ":BufferLinePick<CR>", default_opts)
