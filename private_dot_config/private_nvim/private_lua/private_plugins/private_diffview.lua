---@type LazyPluginSpec
return {
  "dlyongemallo/diffview.nvim",
  ---@type DiffViewOptions
  opts = {
    enhanced_diff_hl = true,
    diffopt = { algorithm = "histogram" },
    default_args = {
      DiffviewOpen = { "--imply-local" },
    },
    file_panel = {
      show_branch_name = true,
    },
  },
}
