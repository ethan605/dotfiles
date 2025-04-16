---@return string
local function folder_label_renderer(path)
  path = path:gsub(os.getenv("HOME"), "~", 1) -- substitute $HOME with ~
  path = path:gsub("/*$", "") -- remove trailing `/` chars
  local cur_dir = path:match("[^/]*$")
  path = path:gsub("[^/]*$", "") -- remove cur_dir
  return path:gsub("([a-zA-Z])[^/]+", "%1") .. cur_dir
end

---@type LazySpec
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
    diagnostics = {
      enable = true,
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
    },
    sync_root_with_cwd = false,
    view = {
      centralize_selection = true,
      width = {
        min = 30,
        max = -1,
      },
    },
  },
  keys = {
    { "<C-o>", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
  },
}
