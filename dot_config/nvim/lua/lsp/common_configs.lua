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
local function on_attach(client)
  local function buf_keymap_set(key, func)
    vim.keymap.set("n", key, func, { noremap = true, silent = true, buffer = true })
  end

  if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(true) end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_keymap_set("gN", vim.lsp.buf.rename)
  buf_keymap_set("K", vim.lsp.buf.hover)
  buf_keymap_set("[d", function() vim.diagnostic.jump({ count = -1, float = false }) end)
  buf_keymap_set("]d", function() vim.diagnostic.jump({ count = 1, float = false }) end)
  buf_keymap_set("<C-k>", vim.diagnostic.open_float)

  -- Keymaps using default vim.lsp.buf utils, replaced by fzf-lua
  -- buf_keymap_set("gd", vim.lsp.buf.definition)
  -- buf_keymap_set("gD", vim.lsp.buf.declaration)
  -- buf_keymap_set("gi", vim.lsp.buf.type_definition)
  -- buf_keymap_set("gI", vim.lsp.buf.implementation)
  -- buf_keymap_set("gr", vim.lsp.buf.references)
  -- buf_keymap_set("<space>gd", ":vsplit | lua vim.lsp.buf.definition()<CR>")
  -- buf_keymap_set("<space>gD", ":vsplit | lua vim.lsp.buf.declaration()<CR>")
  -- buf_keymap_set("<space>gi", ":vsplit | lua vim.lsp.buf.type_definition()<CR>")
  -- buf_keymap_set("<space>gI", ":vsplit | lua vim.lsp.buf.implementation()<CR>")
  -- buf_keymap_set("<space>ca", vim.lsp.buf.code_action)
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
  root_dir = vim.fn.getcwd(),
}
