---@type LazyPluginSpec
return {
  "saghen/blink.cmp",
  version = "1.*",

  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    appearance = { nerd_font_variant = "mono" },

    sources = {
      default = { "lsp", "snippets", "buffer" },
      providers = {
        lsp = {
          fallbacks = {},
        },
      },
    },

    snippets = { preset = "default" },

    keymap = {
      preset = "default",
      ["<C-e>"] = { "cancel", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      menu = {
        draw = {
          columns = {
            { "label",     "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
        },
      },
    },

    cmdline = {
      keymap = {
        preset = "inherit",
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = { menu = { auto_show = true } },
      sources = { "path", "cmdline", "buffer" },
    },
  },
}
