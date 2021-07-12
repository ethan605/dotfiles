local nvim_lsp = require("lspconfig")
local utils = require("lsp.utils")

-- Use a loop to conveniently call `setup` on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  "bashls",
  -- "diagnosticls",
  -- "elixirls",
  "gopls",
  "graphql",
  "html",
  "jsonls",
  "pyright",
  "solargraph",
  "tsserver",
  "vimls",
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = utils.on_attach,
    flags = utils.default_flags,
  }
end

require("lsp.diagnosticls")
require("lsp.sumneko_lua")
