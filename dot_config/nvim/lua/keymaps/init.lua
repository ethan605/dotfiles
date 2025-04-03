local opts = { noremap = true, silent = true }

-- Moving visual blocks
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- Hide search highlights
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", opts)

-- Escape TERMINAL mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)

-- For kulala.nvim
vim.keymap.set({ "n", "v" }, "<leader>Rb", require("kulala").scratchpad, opts)
vim.keymap.set({ "n", "v" }, "<leader>Rs", require("kulala").run, opts)

-- For nvim-ufo
-- vim.keymap.set("n", "zR", require("ufo").openAllFolds, opts)
-- vim.keymap.set("n", "zM", require("ufo").closeAllFolds, opts)
-- vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, opts)
-- vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, opts)
vim.keymap.set("n", "zk", require("ufo").peekFoldedLinesUnderCursor, opts)

require("keymaps.fzf-lua")
-- require("keymaps.nvim-dap")
