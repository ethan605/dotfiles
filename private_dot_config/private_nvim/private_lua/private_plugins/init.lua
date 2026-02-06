-- Download lazy.nvim when missing
local function ensure_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

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
  ui = {
    backdrop = 100,
    border = "rounded",
  },
}

---@type LazyPluginSpec
local plugins = {
  -- Plugins with minimal configs
  "OXY2DEV/helpview.nvim",
  "darfink/vim-plist",
  "mg979/vim-visual-multi",
  "yochem/jq-playground.nvim",

  { "fei6409/log-highlight.nvim", config = true },
  { "kylechui/nvim-surround",     config = true },
  { "windwp/nvim-autopairs",      config = true, event = "InsertEnter" },

  {
    "brianhuster/live-preview.nvim",
    dependencies = { "ibhagwan/fzf-lua" },
  },

  -- Plugins with more complex configs
  require("plugins.bufferline"),
  require("plugins.colorscheme"),
  require("plugins.comment"),
  require("plugins.csvview"),
  require("plugins.dashboard"),
  require("plugins.diffview"),
  require("plugins.fyler"),
  require("plugins.fzf-lua"),
  require("plugins.gitlinker"),
  require("plugins.gitsigns"),
  require("plugins.indent-blankline"),
  require("plugins.leap"),
  require("plugins.lualine"),
  require("plugins.markview"),
  require("plugins.mason"),
  require("plugins.neotest"),
  require("plugins.none-ls"),
  require("plugins.nvim-cmp"),
  require("plugins.nvim-coverage"),
  require("plugins.nvim-dbee"),
  require("plugins.nvim-highlight-colors"),
  require("plugins.nvim-java"),
  require("plugins.nvim-lightbulb"),
  require("plugins.nvim-repl"),
  require("plugins.nvim-tree"),
  require("plugins.nvim-treesitter"),
  require("plugins.nvim-ufo"),
  require("plugins.nvim-window"),
  require("plugins.smartcolumn"),
  require("plugins.todo-comments"),

  -- Temp. disabled plugins
  -- require("plugins.codesnap"),  -- FIXME: needs libpcre2-8.0.dylib
}

require("lazy").setup(plugins, opts)
