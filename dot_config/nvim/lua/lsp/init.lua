vim.lsp.config("*", require("lsp.common"))

vim.lsp.config.bashls = require("lsp.bashls")
vim.lsp.config.clangd = require("lsp.clangd")
vim.lsp.config.diagnosticls = require("lsp.diagnosticls")
vim.lsp.config.docker_compose = require("lsp.docker_compose")
vim.lsp.config.dockerls = require("lsp.dockerls")
vim.lsp.config.eslint = require("lsp.eslint")
vim.lsp.config.gopls = require("lsp.gopls")
vim.lsp.config.harper = require("lsp.harper")
vim.lsp.config.html = require("lsp.html")
vim.lsp.config.jsonls = require("lsp.jsonls")
vim.lsp.config.ltex = require("lsp.ltex")
vim.lsp.config.luals = require("lsp.luals")
vim.lsp.config.nginx = require("lsp.nginx")
vim.lsp.config.pyright = require("lsp.pyright")
vim.lsp.config.ruff = require("lsp.ruff")
vim.lsp.config.rust_analyzer = require("lsp.rust_analyzer")
vim.lsp.config.solargraph = require("lsp.solargraph")
vim.lsp.config.sqls = require("lsp.sqls")
vim.lsp.config.tailwindcss = require("lsp.tailwindcss")
vim.lsp.config.terraformls = require("lsp.terraformls")
vim.lsp.config.tsls = require("lsp.tsls")
vim.lsp.config.vimls = require("lsp.vimls")
vim.lsp.config.yamlls = require("lsp.yamlls")
-- vim.lsp.config.basedpyright = require("lsp.basedpyright")
-- vim.lsp.config.postgres_lsp = require("lsp.postgres_lsp") -- @TODO: to visit later when it's more mature

vim.lsp.enable({
  "bashls",
  "clangd",
  "diagnosticls",
  "docker_compose",
  "dockerls",
  "eslint",
  "gopls",
  "html",
  "jsonls",
  "ltex",
  "luals",
  "nginx",
  "pyright",
  "ruff",
  "rust_analyzer",
  "solargraph",
  "sqls",
  "tailwindcss",
  "terraformls",
  "tsls",
  "vimls",
  "yamlls",
  -- "basedpyright", -- performance issues
  -- "harper", -- on demand
  -- "postgres_lsp", -- not mature enough
})

vim.diagnostic.config({
  virtual_lines = { current_line = true },
})
