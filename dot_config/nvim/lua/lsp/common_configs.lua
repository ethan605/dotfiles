---@type lsp.ClientCapabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local keymap_opts = { noremap = true, silent = true, buffer = true }

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
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true)

    vim.api.nvim_create_user_command("LspInlayHint", function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
    end, { desc = "Toggling inlay_hint feature" })
  end
end

vim.api.nvim_create_user_command("LspToggle", function(args)
  local name = args.args
  if vim.lsp.config[name] == nil then return end

  local lsp_client = vim.lsp.get_clients({ name = name })[1]

  if lsp_client == nil then
    vim.lsp.start(vim.lsp.config[name])
  else
    vim.lsp.stop_client(lsp_client.id, true)
  end
end, { desc = "Toggling a LSP by name", nargs = 1 })

-- python.vim
-- "[[" Jump backwards to begin of current/previous top-level
-- "[]" Jump backwards to end of previous top-level
-- "][" Jump forwards to end of current top-level
-- "]]" Jump forwards to begin of next top-level
-- "[m" Jump backwards to begin of current/previous method/scope
-- "[M" Jump backwards to end of previous method/scope
-- "]M" Jump forwards to end of current/next method/scope
-- "]m" Jump forwards to begin of next method/scope

-- LSP. See `:help vim.lsp.*` for documentation on any of the below functions
vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float, keymap_opts)
vim.keymap.set("n", "gN", vim.lsp.buf.rename, keymap_opts)
-- vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
-- vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = false }) end, keymap_opts)
-- vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = false }) end, keymap_opts)
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymap_opts)
-- vim.keymap.set("n", "gi", vim.lsp.buf.type_definition, keymap_opts)
-- vim.keymap.set("n", "gI", vim.lsp.buf.implementation, keymap_opts)
-- vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
-- vim.keymap.set("n", "<space>gd", ":vsplit | lua vim.lsp.buf.definition()<CR>", keymap_opts)
-- vim.keymap.set("n", "<space>gD", ":vsplit | lua vim.lsp.buf.declaration()<CR>", keymap_opts)
-- vim.keymap.set("n", "<space>gi", ":vsplit | lua vim.lsp.buf.type_definition()<CR>", keymap_opts)
-- vim.keymap.set("n", "<space>gI", ":vsplit | lua vim.lsp.buf.implementation()<CR>", keymap_opts)
-- vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, keymap_opts)

---@type vim.lsp.Config
return {
  capabilities = capabilities,
  on_attach = on_attach,
  root_markers = { ".git" },
}
