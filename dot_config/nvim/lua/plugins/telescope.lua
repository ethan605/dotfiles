require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = "move_selection_previous",
        ["<C-j>"] = "move_selection_next",
      },
      n = {
        ["<C-k>"] = "move_selection_previous",
        ["<C-j>"] = "move_selection_next",
      },
    },
    prompt_prefix = "❯ ",
    selection_caret = "› ",
  },
}
