---@type LazySpec
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
    local nvim_cmp = require("cmp")
    local window_style = nvim_cmp.config.window.bordered({
      winhighlight = "Normal:Normal,FloatBorder:None,CursorLine:PmenuSel,Search:None",
      scrollbar = false,
    })

    ---@type cmp.ConfigSchema
    local opts = {
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
        expandable_indicator = true,
        fields = { "abbr", "kind", "menu" },
        format = require("lspkind").cmp_format({
          mode = "symbol_text",
          preset = "codicons",
          max_width = 50,
          ellipsis_char = "...",
          show_labelDetails = true,
        }),
      },
      mapping = nvim_cmp.mapping.preset.insert({
        ["<C-e>"] = nvim_cmp.mapping.abort(),
        ["<CR>"] = nvim_cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = function(fallback)
          if nvim_cmp.visible() then
            nvim_cmp.select_next_item()
          else
            fallback()
          end
        end,
        ["<S-Tab>"] = function(fallback)
          if nvim_cmp.visible() then
            nvim_cmp.select_prev_item()
          else
            fallback()
          end
        end,
      }),
      window = {
        completion = window_style,
        documentation = window_style,
      },
    }

    nvim_cmp.setup(opts)

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    nvim_cmp.setup.cmdline({ "/", "?" }, {
      mapping = nvim_cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    nvim_cmp.setup.cmdline(":", {
      mapping = nvim_cmp.mapping.preset.cmdline(),
      sources = nvim_cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}
