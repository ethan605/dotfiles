vim.lsp.config("*", require("lsp.common"))

vim.lsp.config.bash_ls = require("lsp.bash_ls")
vim.lsp.config.clangd = require("lsp.clangd")
vim.lsp.config.diagnostic_ls = require("lsp.diagnostic_ls")
vim.lsp.config.docker_compose_ls = require("lsp.docker_compose_ls")
vim.lsp.config.docker_ls = require("lsp.docker_ls")
vim.lsp.config.eslint = require("lsp.eslint")
vim.lsp.config.gopls = require("lsp.gopls")
vim.lsp.config.harper_ls = require("lsp.harper_ls")
vim.lsp.config.html_ls = require("lsp.html_ls")
vim.lsp.config.json_ls = require("lsp.json_ls")
vim.lsp.config.ltex_ls = require("lsp.ltex_ls")
vim.lsp.config.lua_ls = require("lsp.lua_ls")
vim.lsp.config.nginx_ls = require("lsp.nginx_ls")
vim.lsp.config.pyright = require("lsp.pyright")
vim.lsp.config.ruff = require("lsp.ruff")
vim.lsp.config.rust_analyzer = require("lsp.rust_analyzer")
vim.lsp.config.solargraph = require("lsp.solargraph")
vim.lsp.config.sqls = require("lsp.sqls")
vim.lsp.config.tailwindcss = require("lsp.tailwindcss")
vim.lsp.config.terraform_ls = require("lsp.terraform_ls")
vim.lsp.config.ts_ls = require("lsp.ts_ls")
vim.lsp.config.vim_ls = require("lsp.vim_ls")
vim.lsp.config.yaml_ls = require("lsp.yaml_ls")
-- vim.lsp.config.basedpyright = require("lsp.basedpyright")
-- vim.lsp.config.postgres_lsp = require("lsp.postgres_lsp") -- @TODO: to visit later when it's more mature

vim.lsp.enable({
  "bash_ls",
  "clangd",
  "diagnostic_ls",
  "docker_compose_ls",
  "docker_ls",
  "eslint",
  "gopls",
  "html_ls",
  "json_ls",
  "ltex_ls",
  "lua_ls",
  "nginx_ls",
  "pyright",
  "ruff",
  "rust_analyzer",
  "solargraph",
  "sqls",
  "tailwindcss",
  "terraform_ls",
  "ts_ls",
  "vim_ls",
  "yaml_ls",
  -- "basedpyright", -- performance issues
  -- "harper_ls", -- on demand
  -- "postgres_lsp", -- not mature enough
})

vim.diagnostic.config({
  virtual_lines = { current_line = true },
})
