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
  -- Plugins with minimal configs
  "darfink/vim-plist",
  "mg979/vim-visual-multi",
  "sindrets/diffview.nvim",

  {
    "hat0uma/csvview.nvim",
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
  { "kylechui/nvim-surround", config = true },
  { "windwp/nvim-autopairs",  config = true, event = "InsertEnter" },
  {
    "brianhuster/live-preview.nvim",
    dependencies = { "ibhagwan/fzf-lua" },
  },

  -- Common plugins
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
  require("plugins.nvim-lightbulb"),
  require("plugins.nvim-repl"),
  require("plugins.nvim-tree"),
  require("plugins.nvim-treesitter"),
  require("plugins.nvim-ufo"),
  require("plugins.nvim-window"),
  require("plugins.smartcolumn"),
  require("plugins.todo-comments"),
  require("plugins.vim-dadbod-ui"),

  -- Temp. disabled
  -- require("plugins.avante"),
  -- require("plugins.nvim-java"),
}

require("lazy").setup(plugins, opts)
