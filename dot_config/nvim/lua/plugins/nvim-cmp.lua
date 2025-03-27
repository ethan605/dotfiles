return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/nvim-cmp",
    "hrsh7th/vim-vsnip",    -- for Vim commands
    "nvim-lua/plenary.nvim",
    "onsails/lspkind-nvim", -- for LSP pictograms
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = { "saadparwaiz1/cmp_luasnip" },
    },
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
      snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end,
      },
      formatting = {
        format = require("lspkind").cmp_format({
          mode = "symbol_text",
          preset = "codicons",
          max_width = 50,
          ellipsis_char = "...",
          show_labelDetails = true,
        }),
      },
      -- window = {
      --   completion = cmp.config.window.bordered(),
      --   documentation = cmp.config.window.bordered(),
      -- },
      mapping = cmp.mapping.preset.insert({
        -- ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end,
        ["<S-Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end,
      }),
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}
