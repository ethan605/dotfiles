---@type LazyPluginSpec
return {
  "dlyongemallo/diffview.nvim",
  opts = function()
    local actions = require("diffview.actions")

    ---@type DiffViewOptions
    return {
      enhanced_diff_hl = true,
      diffopt = { algorithm = "histogram" },
      default_args = {
        DiffviewOpen = { "--imply-local" },
      },
      file_panel = {
        show_branch_name = true,
        always_show_sections = true,
      },
      view = {
        cycle_layouts = {
          default = { "diff2_horizontal", "diff1_inline" },
          merge_tool = { "diff3_horizontal", "diff3_mixed", "diff4_mixed" },
        },
      },
      keymaps = {
        view = {
          { "n", "]g", actions.cycle_layout, { desc = "Cycle through available layouts." } },
        },
      },
    }
  end,
}
