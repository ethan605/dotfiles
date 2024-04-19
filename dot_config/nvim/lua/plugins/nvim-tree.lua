local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "}}", ":NvimTreeResize +5<CR>", opts("Widen"))
  vim.keymap.set("n", "{{", ":NvimTreeResize -5<CR>", opts("Shrink"))
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
  on_attach = on_attach,
  view = {
    centralize_selection = true,
    width = 50,
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
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
})
