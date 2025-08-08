---@type LazySpec
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
    git = {
      files = { cwd = vim.fn.getcwd() },
    },
    lsp = {
      async_or_timeout = 3000, -- make lsp requests synchronous so they work with none-ls
      jump1 = false,
      references = { cwd = vim.fn.getcwd() },
    },
  },
  keys = function()
    local fzf_buffers = require("fzf-lua.providers.buffers")
    local fzf_diagnostic = require("fzf-lua.providers.diagnostic")
    local fzf_files = require("fzf-lua.providers.files")
    local fzf_git = require("fzf-lua.providers.git")
    local fzf_grep = require("fzf-lua.providers.grep")
    local fzf_lsp = require("fzf-lua.providers.lsp")

    local lsp_opts = { formatter = "path.filename_first" }

    return {
      { "gb",       fzf_buffers.buffers,                          desc = "Browse buffers" },
      { "<C-f>",    fzf_files.files,                              desc = "Browse all files" },
      { "<C-g>",    fzf_git.status,                               desc = "Browse modified/untracked files" },
      { "<C-p>",    fzf_git.files,                                desc = "Browse git tracked files" },
      { "<C-s>",    fzf_grep.grep,                                desc = "Search with prompt",             mode = "n" },
      { "<C-s>",    fzf_grep.grep_visual,                         desc = "Search selected text",           mode = "v" },
      { "<space>s", fzf_lsp.document_symbols,                     desc = "Browse document symbols" },
      { "gra",      fzf_lsp.code_actions,                         desc = "Browse code actions" },

      { "gd",       function() fzf_lsp.definitions(lsp_opts) end, desc = "Go to definition" },
      { "gi",       function() fzf_lsp.typedefs(lsp_opts) end,    desc = "Go to implementation" },
      { "gr",       function() fzf_lsp.references(lsp_opts) end,  desc = "Go to references" },

      {
        "gE",
        function() fzf_diagnostic.diagnostics({ severity_only = true }) end,
        desc = "Browse diagnostics",
      },
    }
  end,
}
