--local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(key, func)
    vim.api.nvim_buf_set_keymap(bufnr, "n", key, func, { noremap = true, silent = true })
  end

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true)
  end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap("gN", ":lua vim.lsp.buf.rename()<CR>")
  buf_set_keymap("K", ":lua vim.lsp.buf.hover()<CR>")
  buf_set_keymap("[d", ":lua vim.diagnostic.goto_prev()<CR>")
  buf_set_keymap("]d", ":lua vim.diagnostic.goto_next()<CR>")
  buf_set_keymap("<C-k>", ":lua vim.lsp.buf.signature_help()<CR>")

  -- Keymaps using default vim.lsp.buf utils
  --buf_set_keymap("gd", ":lua vim.lsp.buf.definition()<CR>")
  --buf_set_keymap("gD", ":lua vim.lsp.buf.declaration()<CR>")
  --buf_set_keymap("gi", ":lua vim.lsp.buf.type_definition()<CR>")
  --buf_set_keymap("gI", ":lua vim.lsp.buf.implementation()<CR>")
  --buf_set_keymap("gr", ":lua vim.lsp.buf.references()<CR>")
  --buf_set_keymap("<space>gd", ":vsplit | lua vim.lsp.buf.definition()<CR>")
  --buf_set_keymap("<space>gD", ":vsplit | lua vim.lsp.buf.declaration()<CR>")
  --buf_set_keymap("<space>gi", ":vsplit | lua vim.lsp.buf.type_definition()<CR>")
  --buf_set_keymap("<space>gI", ":vsplit | lua vim.lsp.buf.implementation()<CR>")
  --buf_set_keymap("<space>ca", ":lua vim.lsp.buf.code_action()<CR>")
end

-- python.vim
-- "[[" Jump backwards to begin of current/previous toplevel
-- "[]" Jump backwards to end of previous toplevel
-- "][" Jump forwards to end of current toplevel
-- "]]" Jump forwards to begin of next toplevel
-- "[m" Jump backwards to begin of current/previous method/scope
-- "[M" Jump backwards to end of previous method/scope
-- "]M" Jump forwards to end of current/next method/scope
-- "]m" Jump forwards to begin of next method/scope

return {
  capabilities = capabilities,
  default_flags = {
    debounce_text_changes = 150,
  },
  on_attach = on_attach,
}
