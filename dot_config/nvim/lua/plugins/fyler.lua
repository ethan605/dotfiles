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
        width = 0.25,
        height = 1,
        kind = "split:leftmost",
        border = "single",
      },
      confirm = {
        width = 0.5,
        height = 0.4,
        kind = "split:below",
        border = "single",
      },
    },
  },
}
