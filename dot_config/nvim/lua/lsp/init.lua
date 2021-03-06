local nvim_lsp = require("lspconfig")
local utils = require("lsp.utils")

-- Use a loop to conveniently call `setup` on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "gopls",
  "graphql",
  "html",
  "jdtls",
  "jsonls",
  "pyright",
  "solargraph",
  "tsserver",
  "vimls",
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities= utils.capabilities,
    flags = utils.default_flags,
    on_attach = utils.on_attach,
  }
end

require("lsp.diagnosticls")
require("lsp.elixirls")
require("lsp.kotlin_language_server")
require("lsp.sumneko_lua")
