local utils = require("lsp.utils")

require("lspconfig").pylsp.setup({
  capabilities = utils.capabilities,
  flags = utils.default_flags,
  on_attach = utils.on_attach,

  settings = {
    pylsp = {
      configurationSources = {},
      plugins = {
        autopep8 = { enabled = false },
        flake8 = { enabled = false },
        mccabe = { enabled = false },
        pycodestyle = { enabled = false },
        pyflake = { enabled = false },
        yapf = { enabled = false },

        rope_autoimport = { enabled = false },
        rope_completion = { enabled = false },
      },
    },
  },
})
