-- Download lazy.nvim when missing
local function ensure_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.uv.fs_stat(lazypath) then
    local out = vim.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    }):wait()

    if out.code ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n" .. out.stderr, "ErrorMsg" },
      }, true, {})
    end
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
  "vifm/vifm.vim",

  { "fei6409/log-highlight.nvim", config = true },
  { "kylechui/nvim-surround",     config = true },
  { "windwp/nvim-autopairs",      config = true, event = "InsertEnter" },

  {
    "brianhuster/live-preview.nvim",
    dependencies = { "ibhagwan/fzf-lua" },
  },

  -- Plugins with more complex configs
  require("plugins.blink"),
  require("plugins.bufferline"),
  require("plugins.codesnap"),
  require("plugins.colorscheme"),
  require("plugins.csvview"),
  require("plugins.dashboard"),
  require("plugins.diffview"),
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
  require("plugins.nvim-coverage"),
  require("plugins.nvim-dbee"),
  require("plugins.nvim-highlight-colors"),
  require("plugins.nvim-java"),
  require("plugins.nvim-lightbulb"),
  require("plugins.nvim-metals"),
  require("plugins.nvim-repl"),
  require("plugins.nvim-tree"),
  require("plugins.nvim-treesitter"),
  require("plugins.nvim-ufo"),
  require("plugins.nvim-web-devicons"),
  require("plugins.nvim-window"),
  require("plugins.smartcolumn"),
  require("plugins.todo-comments"),
}

require("lazy").setup(plugins, opts)

-- codesnap.nvim appends a template-less full .so path to package.cpath,
-- which shadows every later-appended cpath entry for C-module requires (breaks blink.cmp's rust matcher).
-- Drop cpath entries without a '?' template.
-- codesnap is unaffected: it loads its generator during setup, before this runs.
local entries = vim.split(package.cpath, ";")
package.cpath = table.concat(vim.tbl_filter(
  function(entry) return entry:find("?", 1, true) ~= nil end, entries
), ";")
