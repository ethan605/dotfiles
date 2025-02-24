return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    "fzf-native",
    winopts = {
      backdrop = 100,
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
    defaults = {
      formatter = "path.filename_first",
      preview_pager = "delta",
    },
    lsp = {
      async_or_timeout = 3000, -- make lsp requests synchronous so they work with none-ls
      jump1 = false,
      references = { cwd = vim.fn.getcwd() },
    },
  },
}
