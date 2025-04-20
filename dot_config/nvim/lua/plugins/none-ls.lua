---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "gbprod/none-ls-shellcheck.nvim",
  },
  opts = function()
    local none_ls = require("null-ls")

    return {
      sources = {
        -- diagnostics
        none_ls.builtins.diagnostics.mypy,
        none_ls.builtins.diagnostics.sqlfluff.with({
          extra_args = { "--config", vim.fn.expand("~/.config/.sqlfluff") },
        }),
        none_ls.builtins.diagnostics.terraform_validate,
        none_ls.builtins.diagnostics.zsh,

        -- formatters
        none_ls.builtins.formatting.nginx_beautifier,
        none_ls.builtins.formatting.prettier,
        none_ls.builtins.formatting.shfmt,
        none_ls.builtins.formatting.sqlfluff.with({
          extra_args = { "--config", vim.fn.expand("~/.config/.sqlfluff") },
        }),
        -- none_ls.builtins.formatting.stylua.with({
        --   extra_args = { "--config-path", vim.fn.expand("~/.config/.stylua.toml") },
        -- }),
        none_ls.builtins.formatting.terraform_fmt,

        -- from none-ls-extras
        require("none-ls.formatting.ruff"),
        require("none-ls.formatting.ruff_format"),
        require("none-ls.formatting.rustfmt"),

        -- from none-ls-shellcheck
        require("none-ls-shellcheck.code_actions"),
        require("none-ls-shellcheck.diagnostics"),
      },
      on_attach = function()
        vim.keymap.set({ "n", "v" }, "<leader>f", function()
          vim.lsp.buf.format({
            filter = function(client) return client.name == "null-ls" end,
          })
        end, { noremap = true, silent = true, buffer = true })
      end,
    }
  end,
}
