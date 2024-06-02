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

local opts = {
  defaults = {
    lazy = false,
  },
}

require("lazy").setup({
  -- Vimscript plugins - WIP to replace with Lua alternatives
  "connorholyday/vim-snazzy",
  "darfink/vim-plist",
  "easymotion/vim-easymotion",
  "mg979/vim-visual-multi",
  { "liuchengxu/vista.vim", dependencies = { "junegunn/fzf" } },
  { "prettier/vim-prettier", build = "git restore . && yarn install --frozen-lockfile --production" },

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
    config = function()
      require("nvim-surround").setup()
    end,
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
    config = function()
      require("nvim-autopairs").setup()
    end,
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

  -- Language support
  "wesleimp/stylua.nvim",

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
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitlinker").setup()
    end,
  },

  -- LSP & TreeSitter
  "neovim/nvim-lspconfig",
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true },
      })
    end,
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
      "hrsh7th/vim-vsnip", -- for Vim commands
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
    config = function()
      require("lspfuzzy").setup({})
    end,
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
}, opts)
