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
        cmdline = {
          min_keyword_length = function(ctx)
            -- Disable completions for single chars (e.g. :w)
            if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then return 2 end
            return 0
          end,
        },
        lsp = {
          fallbacks = {},
        },
      },
    },

    snippets = { preset = "default" },

    keymap = {
      preset = "default",

      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-e>"] = { "cancel", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      ["<CR>"] = { "select_and_accept", "fallback" },
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
        preset = "cmdline",

        ["<Tab>"] = { "accept", "show_and_insert" },
        ["<S-Tab>"] = { "show_and_insert", "select_prev" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<CR>"] = { "select_accept_and_enter", "fallback" },
      },
      completion = { menu = { auto_show = true } },
    },
  },
}
