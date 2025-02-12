local utils = require("lsp.utils")

require("lspconfig").basedpyright.setup({
  capabilities = utils.capabilities,
  flags = utils.default_flags,
  on_attach = utils.on_attach,

  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      openFilesOnly = true,
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",
        useLibraryCodeForTypes = true,
      },
    },
  },
})
