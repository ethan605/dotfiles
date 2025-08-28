---@type LazySpec
return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  branch = "main",
  ---@type FylerConfig
  opts = {
    icon_provider = "nvim-web-devicons",
    views = {
      explorer = {
        close_on_select = true,
        confirm_simple = false,
        default_explorer = true,
        git_status = true,
        indentscope = {
          enabled = true,
          group = "FylerIndentMarker",
          marker = "│",
        },
        win = {
          border = "single",
          kind_presets = {
            replace = {},
          },
          kind = "replace",
          buf_opts = {},
          win_opts = {},
        },
      },
      confirm = {
        win = {
          border = "single",
          kind_presets = {
            float = {
              height = "0.3rel",
              width = "0.4rel",
              top = "0.3rel",
              left = "0.3rel",
            },
          },
          kind = "float",
          buf_opts = {},
          win_opts = {},
        },
      },
    },
  },
}
