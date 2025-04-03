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
  -- Vimscript plugins. TODO: replace with Lua alternatives
  "darfink/vim-plist",
  "mg979/vim-visual-multi",
  -- require("plugins.vista"),

  -- Common plugins
  require("plugins.bufferline"),
  require("plugins.colorscheme"),
  require("plugins.comment"),
  require("plugins.dashboard"),
  require("plugins.fzf-lua"),
  require("plugins.gitsigns"),
  require("plugins.indent-blankline"),
  require("plugins.leap"),
  require("plugins.lualine"),
  require("plugins.none-ls"),
  require("plugins.nvim-cmp"),
  -- require("plugins.nvim-dap"), TODO: Configure nvim-dap properly
  require("plugins.nvim-highlight-colors"),
  require("plugins.nvim-java"),
  require("plugins.nvim-repl"),
  require("plugins.nvim-tree"),
  require("plugins.nvim-ufo"),
  require("plugins.oil"),
  require("plugins.smartcolumn"),
  require("plugins.todo-comments"),
  require("plugins.vim-dadbod-ui"),

  "sindrets/diffview.nvim",
  { "hat0uma/csvview.nvim",     opts = {} },
  { "kylechui/nvim-surround",   opts = {} },
  { "windwp/nvim-autopairs",    opts = {} },
  { "mistweaverco/kulala.nvim", opts = {}, ft = { "http", "rest" } },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "octo" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "ruifm/gitlinker.nvim",
    opts = {},
    event = "CursorHold",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  },
}

require("lazy").setup(plugins, opts)
