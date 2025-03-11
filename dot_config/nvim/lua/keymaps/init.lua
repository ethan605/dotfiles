local opts = { noremap = true, silent = true }

-- Moving visual blocks
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- Hide search highlights
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", opts)

-- For kulala.nvim
vim.keymap.set({ "n", "v" }, "<leader>Rb", require("kulala").scratchpad, opts)
vim.keymap.set({ "n", "v" }, "<leader>Rs", require("kulala").run, opts)

-- For leap.nvim
vim.keymap.set({ "n", "x", "o" }, "<leader>s", "<Plug>(leap-forward)", opts)
vim.keymap.set({ "n", "x", "o" }, "<leader>S", "<Plug>(leap-backward)", opts)

-- For gitsigns.nvim
vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<CR>", opts)
vim.keymap.set("n", "]c", ":Gitsigns next_hunk<CR>", opts)

-- For nvim-tree
vim.keymap.set("n", "<C-o>", ":NvimTreeToggle<CR>", opts)

-- For nvim-ufo
-- vim.keymap.set("n", "zR", require("ufo").openAllFolds, opts)
-- vim.keymap.set("n", "zM", require("ufo").closeAllFolds, opts)
-- vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, opts)
-- vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, opts)
vim.keymap.set("n", "zK", require("ufo").peekFoldedLinesUnderCursor, opts)

---@diagnostic disable: different-requires
require("keymaps.bufferline")
require("keymaps.fzf-lua")
-- require("keymaps.nvim-dap")
---@diagnostic enable: different-requires
