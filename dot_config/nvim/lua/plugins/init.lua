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

  vim.opt.rtp:prepend(lazypath)
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
  "neovim/nvim-lspconfig",
  require("plugins.bufferline"),
  require("plugins.comment"),
  require("plugins.dashboard"),
  require("plugins.fzf-lua"),
  require("plugins.git-blame"),
  require("plugins.indent-blankline"),
  require("plugins.lsp-progress"), ---@diagnostic disable-line: different-requires
  require("plugins.lspsaga"),
  require("plugins.lualine"),
  require("plugins.none-ls"),
  require("plugins.nvim-cmp"),
  require("plugins.nvim-dap"),
  require("plugins.nvim-highlight-colors"),
  require("plugins.nvim-surround"),
  require("plugins.nvim-tree"),
  require("plugins.smartcolumn"),
  require("plugins.todo-comments"),

  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      highlight = true,
      lsp = {
        auto_attach = true,
        preference = nil,
      },
    },
  },
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").create_default_mappings()
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "windwp/nvim-autopairs",
    opts = {},
  },
  {
    "yaocccc/nvim-foldsign",
    event = "CursorHold",
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      sign_priority = 6,
    },
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}, lazy_opts)
