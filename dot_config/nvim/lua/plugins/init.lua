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

local lazy_opts = {
  defaults = {
    lazy = false,
  },
}

require("lazy").setup({
  -- Vimscript plugins. TODO: replace with Lua alternatives
  "darfink/vim-plist",
  "mg979/vim-visual-multi",
  -- require("plugins.vista"),

  -- Common plugins
  require("plugins.bufferline"),
  require("plugins.colorscheme"),
  require("plugins.comment"),
  require("plugins.dashboard"),
  require("plugins.fzf-lua"), ---@diagnostic disable-line: different-requires
  require("plugins.gitsigns"),
  require("plugins.indent-blankline"),
  require("plugins.lualine"),
  require("plugins.none-ls"),
  require("plugins.nvim-cmp"),
  require("plugins.nvim-highlight-colors"),
  -- require("plugins.nvim-dap"), TODO: Configure nvim-dap properly
  require("plugins.nvim-java"),
  require("plugins.nvim-tree"),
  require("plugins.nvim-ufo"),
  require("plugins.oil"),
  require("plugins.smartcolumn"),
  require("plugins.todo-comments"),
  require("plugins.vim-dadbod-ui"),

  "ggandor/leap.nvim",
  "sindrets/diffview.nvim",
  { "hat0uma/csvview.nvim",                         opts = {} },
  { "kylechui/nvim-surround",                       opts = {} },
  { "windwp/nvim-autopairs",                        opts = {} },
  { "https://git.sr.ht/~whynothugo/lsp_lines.nvim", opts = {}, event = "LspAttach" },
  { "mistweaverco/kulala.nvim",                     opts = {}, ft = { "http", "rest" } },
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

  -- LSPs & TreeSitter
  "neovim/nvim-lspconfig",
  { "nvim-treesitter/nvim-treesitter",             build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter/nvim-treesitter" } },
}, lazy_opts)
