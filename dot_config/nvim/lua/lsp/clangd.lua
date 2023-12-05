local utils = require("lsp.utils")

require("lspconfig").clangd.setup({
  capabilities = utils.capabilities,
  flags = utils.default_flags,
  on_attach = utils.on_attach,
})
