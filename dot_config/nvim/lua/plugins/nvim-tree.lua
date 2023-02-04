require("nvim-tree").setup {
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  filters = {
    custom = {
      ".git",
      ".gitlab",
      "node_modules",
      "venv",
    },
  },
  hijack_cursor = true,
  renderer = {
    highlight_git = true,
    highlight_opened_files = "all",
    icons = {
      show = {
        --git = 1,
        folder = true,
        file = true,
        folder_arrow = true,
      },
    },
  },
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
}
