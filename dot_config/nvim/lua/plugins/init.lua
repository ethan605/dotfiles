-- Download lazy.nvim when missing
local function ensure_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  ---@diagnostic disable-next-line: undefined-field
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end

  vim.opt.runtimepath:prepend(lazypath)
end

ensure_lazy()

---@type LazyConfig
local opts = {
  defaults = {
    lazy = false,
  },
}

---@type LazyPluginSpec
local plugins = {
  "darfink/vim-plist",
  "mg979/vim-visual-multi",

  -- Common plugins
  require("plugins.avante"),
  require("plugins.bufferline"),
  require("plugins.colorscheme"),
  require("plugins.comment"),
  require("plugins.dashboard"),
  require("plugins.fyler"),
  require("plugins.fzf-lua"),
  require("plugins.gitlinker"),
  require("plugins.gitsigns"),
  require("plugins.indent-blankline"),
  require("plugins.leap"),
  require("plugins.lualine"),
  require("plugins.markview"),
  require("plugins.none-ls"),
  require("plugins.nvim-cmp"),
  require("plugins.nvim-coverage"),
  require("plugins.nvim-dbee"),
  require("plugins.nvim-highlight-colors"),
  -- require("plugins.nvim-java"),
  require("plugins.nvim-repl"),
  require("plugins.nvim-tree"),
  require("plugins.nvim-ufo"),
  require("plugins.smartcolumn"),
  require("plugins.todo-comments"),
  require("plugins.vim-dadbod-ui"),

  "sindrets/diffview.nvim",
  { "hat0uma/csvview.nvim",   opts = {} },
  { "kylechui/nvim-surround", opts = {} },
  { "windwp/nvim-autopairs",  opts = {} },
  {
    "brianhuster/live-preview.nvim",
    dependencies = { "ibhagwan/fzf-lua" },
  },
  {
    "kosayoda/nvim-lightbulb",
    ---@type nvim-lightbulb.Config
    opts = {
      autocmd = { enabled = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  },
}

require("lazy").setup(plugins, opts)
