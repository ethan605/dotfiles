---@type lsp.ClientCapabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

    vim.api.nvim_create_user_command(
      "LspInlayHint", function()
        local enabled = vim.lsp.inlay_hint.is_enabled()
        vim.lsp.inlay_hint.enable(not enabled)
      end,
      { desc = "Toggling inlay_hint feature" }
    )
  end

  if client:supports_method("textDocument/formatting", bufnr) then
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format()
    end)
  end
end

vim.api.nvim_create_user_command(
  "LspToggle",
  function(args)
    local name = args.args
    if vim.lsp.config[name] == nil then return end

    local lsp_client = vim.lsp.get_clients({ name = name })[1]

    if lsp_client == nil then
      vim.lsp.start(vim.lsp.config[name])
    else
      vim.lsp.stop_client(lsp_client.id, true)
    end
  end,
  { desc = "Toggling a LSP by name", nargs = 1 }
)

-- python.vim
-- "[[" Jump backwards to begin of current/previous top-level
-- "[]" Jump backwards to end of previous top-level
-- "][" Jump forwards to end of current top-level
-- "]]" Jump forwards to begin of next top-level
-- "[m" Jump backwards to begin of current/previous method/scope
-- "[M" Jump backwards to end of previous method/scope
-- "]M" Jump forwards to end of current/next method/scope
-- "]m" Jump forwards to begin of next method/scope

---@type vim.lsp.Config
return {
  capabilities = capabilities,
  on_attach = on_attach,
  root_markers = { ".git" },
}
