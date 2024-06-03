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
  "easymotion/vim-easymotion",
  "mg979/vim-visual-multi",
  {
    "liuchengxu/vista.vim",
    dependencies = { "junegunn/fzf" },
  },

  -- Common plugins
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("plugins.nvim-highlight-colors")
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("plugins.comment")
    end,
  },
  {
    "kylechui/nvim-surround",
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins.indent-blankline")
    end,
  },
  {
    "windwp/nvim-autopairs",
    opts = {},
  },
  {
    "hoob3rt/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.lualine")
    end,
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.fzf-lua")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.nvim-tree")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.bufferline")
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.dashboard")
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "HACK" } },
        TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        TODO = { icon = " ", color = "info", alt = { "NOTE", "INFO" } },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "DANGER", "ALARM" } },
      },
    },
  },

  -- Git
  {
    "f-person/git-blame.nvim",
    config = function()
      require("plugins.git-blame")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- LSP
  "neovim/nvim-lspconfig",
  {
    "kosayoda/nvim-lightbulb",
    opts = {
      autocmd = { enabled = true },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/nvim-cmp",
      "hrsh7th/vim-vsnip",    -- for Vim commands
      "nvim-lua/plenary.nvim",
      "onsails/lspkind-nvim", -- for LSP pictograms
      { "tzachar/cmp-tabnine", build = "./install.sh" },
    },
    config = function()
      require("plugins.nvim-cmp")
    end,
  },
  {
    "norcalli/snippets.nvim",
    config = function()
      require("snippets").use_suggested_mappings()
    end,
  },
  {
    "ojroques/nvim-lspfuzzy",
    opts = {},
  },
  {
    "nvimdev/lspsaga.nvim",
    dependencies = { "nvim-lspconfig" },
    config = function()
      require("plugins.lspsaga")
    end,
  },
  {
    "linrongbin16/lsp-progress.nvim",
    config = function()
      require("plugins.lsp-progress")
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      require("plugins.none-ls")
    end,
  },

  -- TreeSitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- DAP - disabled due to no active usage
  {
    "mfussenegger/nvim-dap",
    enabled = false,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "nvim-dap-python",
      "nvim-dap-ui",
      "nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("plugins.nvim-dap").setup()
    end,
  },
}, lazy_opts)
