-- Disabled due to no active usage
-- cssls
-- denols
-- elixirls
-- graphql
-- kotlin_language_server
-- postgres_lsp @TODO: to visit later when it's more mature
-- solargraph
-- vimls

vim.diagnostic.config(require("lsp.diagnostic_configs"))
vim.lsp.config("*", require("lsp.common_configs"))

-- vim.lsp.config.basedpyright = require("lsp.basedpyright")
vim.lsp.config.bash_ls = require("lsp.bash_ls")
vim.lsp.config.clangd = require("lsp.clangd")
vim.lsp.config.diagnostic_ls = require("lsp.diagnostic_ls")
vim.lsp.config.docker_compose_ls = require("lsp.docker_compose_ls")
vim.lsp.config.docker_ls = require("lsp.docker_ls")
vim.lsp.config.eslint = require("lsp.eslint")
vim.lsp.config.gopls = require("lsp.gopls")
vim.lsp.config.html_ls = require("lsp.html_ls")
vim.lsp.config.json_ls = require("lsp.json_ls")
vim.lsp.config.ltex = require("lsp.ltex")
vim.lsp.config.lua_ls = require("lsp.lua_ls")
vim.lsp.config.pyright = require("lsp.pyright")
vim.lsp.config.ruff = require("lsp.ruff")
vim.lsp.config.rust_analyzer = require("lsp.rust_analyzer")
vim.lsp.config.sqls = require("lsp.sqls")
vim.lsp.config.tailwindcss = require("lsp.tailwindcss")
vim.lsp.config.terraform_ls = require("lsp.terraform_ls")
vim.lsp.config.ts_ls = require("lsp.ts_ls")
vim.lsp.config.yaml_ls = require("lsp.yaml_ls")

vim.lsp.enable({
  -- "basedpyright",
  "bash_ls",
  "clangd",
  "diagnostic_ls",
  "docker_compose_ls",
  "docker_ls",
  "eslint",
  "gopls",
  "html_ls",
  "json_ls",
  "ltex",
  "lua_ls",
  "pyright",
  "ruff",
  "rust_analyzer",
  "sqls",
  "tailwindcss",
  "terraform_ls",
  "ts_ls",
  "yaml_ls",
})
