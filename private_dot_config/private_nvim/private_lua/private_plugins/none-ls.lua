local function get_sqlfluff_config()
  local target = os.getenv("SQL_TARGET") or "postgres"

  return {
    extra_args = {
      "--config",
      vim.fn.expand("~/.config/.sqlfluff." .. target),
    },
  }
end

---@type LazyPluginSpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "gbprod/none-ls-shellcheck.nvim",
  },
  opts = function()
    local none_ls = require("null-ls")
    local sqlfluff_config = get_sqlfluff_config()

    return {
      sources = {
        -- diagnostics
        none_ls.builtins.diagnostics.mypy,
        none_ls.builtins.diagnostics.sqlfluff.with(sqlfluff_config),
        none_ls.builtins.diagnostics.terraform_validate,
        none_ls.builtins.diagnostics.zsh,

        -- formatters
        none_ls.builtins.formatting.clang_format,
        none_ls.builtins.formatting.nginx_beautifier,
        none_ls.builtins.formatting.nixpkgs_fmt,
        none_ls.builtins.formatting.prettier,
        none_ls.builtins.formatting.shfmt,
        none_ls.builtins.formatting.sqlfluff.with(sqlfluff_config),
        none_ls.builtins.formatting.terraform_fmt,
        -- NOTE: stylua has conflicts with lua-language-server's formatting rules
        -- none_ls.builtins.formatting.stylua.with({
        --   extra_args = { "--config-path", vim.fn.expand("~/.config/.stylua.toml") },
        -- }),

        -- from none-ls-extras
        require("none-ls.diagnostics.cpplint").with({ filetypes = { "cpp" } }),
        require("none-ls.formatting.ruff"),
        require("none-ls.formatting.ruff_format"),
        require("none-ls.formatting.rustfmt"),

        -- FIXME: shellcheck has a serious memory leak
        -- from none-ls-shellcheck
        -- require("none-ls-shellcheck.code_actions"),
        -- require("none-ls-shellcheck.diagnostics"),
      },
      on_attach = function()
        vim.keymap.set({ "n", "v" }, "<Leader>f", function()
          vim.lsp.buf.format({
            filter = function(client) return client.name == "null-ls" end,
            timeout_ms = 5000,
          })
        end, { noremap = true, silent = true, buffer = true })
      end,
    }
  end,
}
