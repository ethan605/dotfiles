---@type LazyPluginSpec
return {
  "pappasam/nvim-repl",
  lazy = false,
  config = true,
  init = function()
    ---@type ReplCmd
    local python = {
      cmd = table.concat({
        "ipython",
        "--TerminalInteractiveShell.editing_mode=emacs",
        "--quiet",
        "--no-autoindent",
        "-i",
        "-c",
        "\"%config InteractiveShell.ast_node_interactivity='last_expr_or_assign'\"",
      }, " "),
      repl_type = "ipython",
      filetype = "python",
    }

    ---@type ReplGlobalConfig
    vim.g.repl = {
      filetype_commands = {
        bash = { cmd = "bash", filetype = "bash" },
        javascript = { cmd = "node", filetype = "javascript" },
        python = python,
        sh = { cmd = "sh", filetype = "sh" },
        typescript = { cmd = 'ts-node -O \'{"module": "commonjs"}\'', filetype = "typescript" },
        vim = { cmd = "nvim --clean -ERM", filetype = "vim" },
      },
      default = python,
      open_window_default = "vertical split new",
    }
  end,
  keys = {
    { "<Leader>rc", "<Plug>(ReplSendCell)",   mode = "n", desc = "Send Repl Cell" },
    { "<Leader>rc", "<Plug>(ReplSendVisual)", mode = "x", desc = "Send Repl Visual Selection" },
    { "<Leader>rn", ":ReplNewCell<CR>",       mode = "n", desc = "New Repl Cell" },
    { "<Leader>rx", ":ReplClear<CR>",         mode = "n", desc = "Clear Repl Buffer" },
  },
}
