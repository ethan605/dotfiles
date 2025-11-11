---@type LazySpec
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    "fzf-native",
    ---@type fzf-lua.config.Winopts
    ---@diagnostic disable-next-line: missing-fields
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
        scrolloff = 0,
        scrollchars = { "█", "" },
      },
    },

    ---@type fzf-lua.config.Keymap
    keymap = {
      builtin = {}, -- clear builtin keymaps
      fzf = {
        ["ctrl-e"] = "preview-down",
        ["ctrl-y"] = "preview-up",
        ["ctrl-d"] = "preview-page-down",
        ["ctrl-u"] = "preview-page-up",
      },
    },

    ---@type fzf-lua.config.Defaults
    ---@diagnostic disable-next-line: missing-fields
    defaults = {
      formatter = "path.filename_first",
      preview_pager = "delta",
    },

    ---@type fzf-lua.config.Git
    ---@diagnostic disable-next-line: missing-fields
    git = {
      ---@diagnostic disable-next-line: missing-fields
      files = { cwd = vim.fn.getcwd() },
    },

    ---@type fzf-lua.config.Lsp
    ---@diagnostic disable-next-line: missing-fields
    lsp = {
      async_or_timeout = 3000, -- make lsp requests synchronous so they work with none-ls
      jump1 = false,
      -- references = { cwd = vim.fn.getcwd() },
    },
  },
  keys = function()
    local fzf_buffers = require("fzf-lua.providers.buffers")
    local fzf_diagnostic = require("fzf-lua.providers.diagnostic")
    local fzf_files = require("fzf-lua.providers.files")
    local fzf_git = require("fzf-lua.providers.git")
    local fzf_grep = require("fzf-lua.providers.grep")
    local fzf_lsp = require("fzf-lua.providers.lsp")

    return {
      { "gb",       fzf_buffers.buffers,            desc = "Browse buffers" },
      { "<C-f>",    fzf_files.files,                desc = "Browse all files" },
      { "<C-g>",    fzf_git.status,                 desc = "Browse modified/untracked files" },
      { "<C-p>",    fzf_git.files,                  desc = "Browse git tracked files" },
      { "<C-s>",    fzf_grep.grep,                  desc = "Search with prompt",             mode = "n" },
      { "<C-s>",    fzf_grep.grep_visual,           desc = "Search selected text",           mode = "v" },
      { "<space>s", fzf_lsp.document_symbols,       desc = "Browse document symbols" },
      { "<space>S", fzf_lsp.live_workspace_symbols, desc = "Search workspace symbols" },
      { "gra",      fzf_lsp.code_actions,           desc = "Browse code actions" },
      { "gd",       fzf_lsp.definitions,            desc = "Go to definition" },
      { "gr",       fzf_lsp.references,             desc = "Go to references" },

      {
        "gE",
        ---@diagnostic disable-next-line: missing-fields
        function() fzf_diagnostic.diagnostics({ severity_only = true }) end,
        desc = "Browse diagnostics",
      },
    }
  end,
}
