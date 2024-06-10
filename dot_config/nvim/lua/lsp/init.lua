local lspconfig = require("lspconfig")
local utils = require("lsp.utils")

-- Use a loop to conveniently call `setup` on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  "bashls",
  "docker_compose_language_service",
  "dockerls",
  "eslint",
  "html",
  "jsonls",
  "ltex",
  "tailwindcss",
  "yamlls",
  -- "cssls", -- disabled in favour of tailwindcss
  -- "denols", -- disabled due to no active usage
  -- "gopls", -- disabled due to no active usage
  -- "graphql", -- disabled due to no active usage
  -- "solargraph", -- disabled due to no active usage
  -- "terraformls", -- disabled due to no active usage
  -- "vimls", -- disabled due to no active usage
}

for _, server in ipairs(servers) do
  lspconfig[server].setup({
    capabilities = utils.capabilities,
    flags = utils.default_flags,
    on_attach = utils.on_attach,
  })
end

require("lsp.basedpyright")
require("lsp.diagnosticls")
require("lsp.lua_ls")
require("lsp.rust_analyzer")
require("lsp.tsserver")

-- disabled due to no active usage
-- require("lsp.clangd")
-- require("lsp.elixirls")
-- require("lsp.jdtls")
-- require("lsp.kotlin_language_server")
