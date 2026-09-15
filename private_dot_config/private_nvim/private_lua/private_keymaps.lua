local opts = { noremap = true, silent = true }

-- Moving visual blocks
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- Hide search highlights
vim.keymap.set("n", "<Leader><Space>", ":nohlsearch<CR>", opts)

-- Escape TERMINAL mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", opts)

-- LSP. See `:help vim.lsp.*`; gd/gr/gra/grn/K/[d/]d etc. are core defaults since 0.11
vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<Leader>f", vim.lsp.buf.format, opts)
