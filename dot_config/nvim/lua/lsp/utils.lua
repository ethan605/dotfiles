local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
  local default_opts = { noremap = true, silent = true }
  local function buf_set_keymap(key, func)
    vim.api.nvim_buf_set_keymap(bufnr, "n", key, func, default_opts)
  end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap("gD", ":lua vim.lsp.buf.declaration()<CR>")
  buf_set_keymap("gd", ":lua vim.lsp.buf.definition()<CR>")
  buf_set_keymap("gi", ":lua vim.lsp.buf.implementation()<CR>")
  buf_set_keymap("gr", ":lua vim.lsp.buf.references()<CR>")
  buf_set_keymap("K", ":lua vim.lsp.buf.hover()<CR>")
  buf_set_keymap("[d", ":lua vim.lsp.diagnostic.goto_prev()<CR>")
  buf_set_keymap("]d", ":lua vim.lsp.diagnostic.goto_next()<CR>")
  buf_set_keymap("<C-k>", ":lua vim.lsp.buf.signature_help()<CR>")
  buf_set_keymap("<space>D", ":lua vim.lsp.buf.type_definition()<CR>")
  buf_set_keymap("<space>ca", ":lua vim.lsp.buf.code_action()<CR>")
  buf_set_keymap("<space>e", ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
  buf_set_keymap("<space>f", ":lua vim.lsp.buf.formatting()<CR>")
  buf_set_keymap("<space>q", ":lua vim.lsp.diagnostic.set_loclist()<CR>")
  buf_set_keymap("<space>rn", ":lua vim.lsp.buf.rename()<CR>")
  buf_set_keymap("<space>wa", ":lua vim.lsp.buf.add_workspace_folder()<CR>")
  buf_set_keymap("<space>wl", ":lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
  buf_set_keymap("<space>wr", ":lua vim.lsp.buf.remove_workspace_folder()<CR>")
end

return {
  capabilities = capabilities,
  default_flags = {
    debounce_text_changes = 150,
  },
  on_attach = on_attach,
}
