local function folder_label_renderer(path)
  path = path:gsub(os.getenv("HOME"), "~", 1) -- substitute $HOME with ~
  path = path:gsub("/*$", "") -- remove trailing `/` chars
  local cur_dir = path:match("[^/]*$")
  path = path:gsub("[^/]*$", "") -- remove cur_dir
  return path:gsub("([a-zA-Z])[^/]+", "%1") .. cur_dir
end

require("nvim-tree").setup({
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
  hijack_cursor = true,
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
    root_folder_label = folder_label_renderer,
  },
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  view = {
    centralize_selection = true,
    width = {
      min = 30,
      max = -1,
    },
  },
})
