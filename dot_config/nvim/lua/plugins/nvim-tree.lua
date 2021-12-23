require("nvim-tree").setup {
  filters = {
    custom = {
      ".git",
      ".gitlab",
      "node_modules",
      "venv",
    },
  },
  hijack_cursor = true,
  ignore_ft_on_setup = { "startify" },
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
}
