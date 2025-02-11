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
  -- Vimscript plugins
  -- TODO: replace with Lua alternatives
  "connorholyday/vim-snazzy",
  "darfink/vim-plist",
  "mg979/vim-visual-multi",
  {
    "liuchengxu/vista.vim",
    dependencies = { "junegunn/fzf" },
  },

  -- Common plugins
  require("plugins.bufferline"),
  require("plugins.comment"),
  require("plugins.dashboard"),
  require("plugins.fzf-lua"), ---@diagnostic disable-line: different-requires
  require("plugins.gitsigns"),
  require("plugins.indent-blankline"),
  require("plugins.lualine"),
  require("plugins.none-ls"),
  require("plugins.nvim-cmp"),
  require("plugins.nvim-dap"),
  require("plugins.nvim-highlight-colors"),
  require("plugins.nvim-tree"),
  require("plugins.nvim-ufo"),
  require("plugins.smartcolumn"),
  require("plugins.todo-comments"),

  "ggandor/leap.nvim",
  "neovim/nvim-lspconfig",
  {
    "kylechui/nvim-surround",
    opts = {},
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    opts = {},
    enabled = false,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "windwp/nvim-autopairs",
    opts = {},
  },
  {
    "ruifm/gitlinker.nvim",
    event = "CursorHold",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}, lazy_opts)
