local none_ls = require("null-ls")

none_ls.setup({
  sources = {
    none_ls.builtins.formatting.prettier,
    none_ls.builtins.formatting.stylua.with({
      extra_args = { "--config-path", vim.fn.expand("~/.config/.stylua.toml") },
    }),
    none_ls.builtins.completion.spell,
  },
})
