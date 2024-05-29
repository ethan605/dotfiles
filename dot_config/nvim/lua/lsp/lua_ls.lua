-- vim:fileencoding=utf-8:filetype=lua
local utils = require("lsp.utils")

require("lspconfig").lua_ls.setup({
  capabilities = utils.capabilities,
  flags = utils.default_flags,
  on_attach = utils.on_attach,

  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
})
