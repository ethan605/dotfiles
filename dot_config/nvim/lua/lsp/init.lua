-- local lspconfig = require("lspconfig")
-- local utils = require("lsp.common_configs")

local legacy_servers_with_configs = {
  -- Plug-n-Play LSPs
  docker_compose_language_service = {},
  dockerls = {},
  eslint = {},
  gopls = {},
  html = {},
  jdtls = {},
  jsonls = {},
  sqls = {},
  tailwindcss = {},
  terraformls = {},
  yamlls = {},

  -- Custom LSPs
  bashls = {
    filetypes = { "zsh", "bash", "sh" },
  },
  ltex = {
    settings = {
      ltex = {
        language = "en-GB",
      },
    },
  },

  -- Disabled due to no active usage
  -- cssls = {},
  -- denols = {},
  -- elixirls = {}
  -- graphql = {},
  -- kotlin_language_server = {},
  -- postgres_lsp = {}, @TODO: to visit later when it's more mature
  -- solargraph = {},
  -- vimls = {},

  -- clangd = {
  --   cmd = { "/opt/homebrew/opt/llvm/bin/clangd", "--clang-tidy" },
  --   settings = {
  --     clangd = {
  --       InlayHints = {
  --         Designators = true,
  --         Enabled = true,
  --         ParameterNames = true,
  --         DeducedTypes = true,
  --       },
  --       fallbackFlags = { "-std=c++20" },
  --     },
  --   },
  -- },
  -- pylyzer = {
  --   python = {
  --     checkOnType = false,
  --     diagnostics = true,
  --     inlayHints = true,
  --     smartCompletion = true,
  --   },
  -- },
}

-- for server, configs in pairs(legacy_servers_with_configs) do
--   local settings = {
--     capabilities = utils.capabilities,
--     flags = utils.default_flags,
--     on_attach = utils.on_attach,
--   }
--
--   -- Merge server configs to settings object
--   for k, v in pairs(configs) do
--     settings[k] = v
--   end
--
--   lspconfig[server].setup(settings)
-- end

vim.diagnostic.config(require("lsp.diagnostic_configs"))
vim.lsp.config("*", require("lsp.common_configs"))

vim.lsp.config.basedpyright = require("lsp.basedpyright")
vim.lsp.config.diagnostic_ls = require("lsp.diagnostic_ls")
vim.lsp.config.lua_ls = require("lsp.lua_ls")
vim.lsp.config.pyright = require("lsp.pyright")
vim.lsp.config.ruff = require("lsp.ruff")
vim.lsp.config.rust_analyzer = require("lsp.rust_analyzer")
vim.lsp.config.ts_ls = require("lsp.ts_ls")

vim.lsp.enable({
  -- "basedpyright",
  "diagnostic_ls",
  "lua_ls",
  "pyright",
  "ruff",
  "rust_analyzer",
  "ts_ls",
})
