---@class lsp.ClientCapabilities
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

---Use an on_attach function to only map the following keys
---after the language server attaches to the current buffer
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(true) end

  -- local opts = { noremap = true, silent = true, buffer = true }
  -- vim.keymap.set("n", "<C-i>", function()
  --   local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  --   vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  -- end, opts)
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

---@class vim.lsp.Config
return {
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = vim.fn.getcwd(),
}
