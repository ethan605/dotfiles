local utils = require("lsp.utils")

require("lspconfig").basedpyright.setup({
  capabilities = utils.capabilities,
  flags = utils.default_flags,
  on_attach = utils.on_attach,

  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
})
