return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvimtools/none-ls-extras.nvim" },
  config = function()
    local none_ls = require("null-ls")

    none_ls.setup({
      sources = {
        -- diagnostics
        none_ls.builtins.diagnostics.mypy,
        none_ls.builtins.diagnostics.terraform_validate,
        none_ls.builtins.diagnostics.zsh,

        -- formatters
        none_ls.builtins.formatting.pg_format,
        none_ls.builtins.formatting.prettier,
        none_ls.builtins.formatting.shfmt,
        none_ls.builtins.formatting.stylua.with({
          extra_args = { "--config-path", vim.fn.expand("~/.config/.stylua.toml") },
        }),
        none_ls.builtins.formatting.terraform_fmt,

        -- from none-ls-extras
        require("none-ls.formatting.ruff"),
        require("none-ls.formatting.ruff_format"),
        require("none-ls.formatting.rustfmt"),
      },
      on_attach = function()
        vim.keymap.set({ "n", "v" }, "<leader>f", vim.lsp.buf.format, { noremap = true, silent = true, buffer = true })
      end,
    })
  end,
}
