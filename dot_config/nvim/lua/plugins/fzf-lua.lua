require("fzf-lua").setup({
  "fzf-native",
  winopts = {
    height = 0.9,
    width = 0.9,
    preview = {
      border = "noborder",
      default = "bat",
      horizontal = "right:50%",
      layout = "horizontal",
      scrollbar = "border",
      scrolloff = "0",
      scrollchars = { "█", "" },
    },
  },
  keymap = {
    builtin = {}, -- clear builtin keymaps
    fzf = {
      ["ctrl-e"] = "preview-down",
      ["ctrl-y"] = "preview-up",
      ["ctrl-d"] = "preview-page-down",
      ["ctrl-u"] = "preview-page-up",
    },
  },
  buffers = { formatter = "path.filename_first" },
  files = { formatter = "path.filename_first" },
  grep = { formatter = "path.filename_first" },
  grep_visual = { formatter = "path.filename_first" },
  live_grep = { formatter = "path.filename_first" },
  git = {
    files = { formatter = "path.filename_first" },
    status = { formatter = "path.filename_first" },
  },
  lsp = {
    finder = { formatter = "path.filename_first" },
  },
})
