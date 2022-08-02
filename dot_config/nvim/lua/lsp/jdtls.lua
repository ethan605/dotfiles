-- vim:fileencoding=utf-8:filetype=lua
local lspconfig = require("lspconfig")
local utils = require("lsp.utils")

lspconfig.jdtls.setup{
  capabilities = utils.capabilities,
  flags = utils.default_flags,
  on_attach = utils.on_attach,
  cmd = { "jdtls" },
  root_dir = function(fname)
    return lspconfig.util.root_pattern('pom.xml', 'gradle.build', '.git')(fname) or vim.fn.getcwd()
  end
}
