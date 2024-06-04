local none_ls = require("null-ls")

none_ls.setup({
  sources = {
    -- diagnostics
    none_ls.builtins.diagnostics.zsh,

    -- formatters
    none_ls.builtins.formatting.pg_format,
    none_ls.builtins.formatting.prettier,
    none_ls.builtins.formatting.shfmt,
    none_ls.builtins.formatting.stylua.with({
      extra_args = { "--config-path", vim.fn.expand("~/.config/.stylua.toml") },
    }),
  },
})
