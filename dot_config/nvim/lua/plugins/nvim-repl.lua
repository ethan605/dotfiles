---@type LazySpec
return {
  "pappasam/nvim-repl",
  opts = {
    filetype_commands = {
      python = { cmd = { "ipython", "--no-autoindent" }, filetype = "python" },
    },
    open_window_default = "vertical split new",
  },
  lazy = false,
  keys = {
    { "<Leader>rc", "<Plug>(ReplSendCell)",   mode = "n", desc = "Send Repl Cell" },
    { "<Leader>rc", "<Plug>(ReplSendVisual)", mode = "x", desc = "Send Repl Visual Selection" },
    { "<Leader>rl", "<Plug>(ReplSendLine)",   mode = "n", desc = "Send Repl Line" },
  },
}
