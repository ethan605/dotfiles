local snazzy_colors = require("lua.colorscheme").snazzy_colors

---@type LazyPluginSpec
return {
  "mistricky/codesnap.nvim",
  tag = "v2.0.0-beta.17",
  opts = {
    show_line_number = true,
    show_workspace = true,
    snapshot_config = {
      code_config = {
        breadcrumbs = {
          enable = true,
          separator = "/",
          color = snazzy_colors.magenta,
          font_family = "OperatorMonoSSm Nerd Font",
        },
      },
      fonts_folders = {
        vim.fn.expand("~/Library/Fonts"),
      },
    },
    watermark = {
      content = "CodeSnap.nvim",
      font_family = "OperatorMonoSSm Nerd Font",
      color = snazzy_colors.white,
    },
  },
}
