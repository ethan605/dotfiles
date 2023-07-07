require("nvim-tree").setup {
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  filters = {
    custom = {
      "node_modules",
      "venv",
    },
  },
  view = {
    centralize_selection = true,
  },
  renderer = {
    highlight_git = true,
    highlight_opened_files = "all",
    icons = {
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
    },
  },
  update_cwd = false,
  update_focused_file = {
    enable = true,
    update_cwd = false,
  },
}
