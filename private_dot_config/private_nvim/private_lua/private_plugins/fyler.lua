---@type LazyPluginSpec
return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  branch = "stable",
  ---@type FylerConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    icon_provider = "nvim_web_devicons",
    hooks = {},
    mappings = {
      ["q"] = "CloseView",
      ["<CR>"] = "Select",
      ["^"] = "GotoParent",
      ["."] = "GotoCwd",
    },
    close_on_select = true,
    confirm_simple = false,
    default_explorer = true,
    git_status = {
      enabled = false,
    },
    indentscope = {
      enabled = true,
    },
    track_current_buffer = true,
    win = {
      kind_presets = {
        replace = {},
      },
      kind = "replace",
    },
  },
}
