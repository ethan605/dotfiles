local opts = { noremap = true, silent = true }

-- Moving visual blocks
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- Hide search highlights
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", opts)

-- Escape TERMINAL mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", opts)

-- LSP. See `:help vim.lsp.*` for documentation on any of the below functions
vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float, opts)
-- vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
-- vim.keymap.set("n", "<space>gD", ":vsplit | lua vim.lsp.buf.declaration()<CR>", opts)
-- vim.keymap.set("n", "<space>gI", ":vsplit | lua vim.lsp.buf.implementation()<CR>", opts)
-- vim.keymap.set("n", "<space>gd", ":vsplit | lua vim.lsp.buf.definition()<CR>", opts)
-- vim.keymap.set("n", "<space>gi", ":vsplit | lua vim.lsp.buf.type_definition()<CR>", opts)
-- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
-- vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = false }) end, opts)
-- vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = false }) end, opts)
-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
-- vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
-- vim.keymap.set("n", "gi", vim.lsp.buf.type_definition, opts)
-- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
-- vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
