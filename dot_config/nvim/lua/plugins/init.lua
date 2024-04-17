-- Automatically install Packer for the first time
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[ packadd packer.nvim ]])
    return true
  end

  return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- Common plugins
  use("airblade/vim-rooter")
  use("alker0/chezmoi.vim")
  use("connorholyday/vim-snazzy")
  use("easymotion/vim-easymotion")
  use("editorconfig/editorconfig-vim")
  use("folke/lsp-colors.nvim")
  use("liuchengxu/vista.vim")
  use("preservim/nerdcommenter")
  use("tpope/vim-surround")
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install" })
  use({ "mg979/vim-visual-multi", branch = "master" })
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins.indent-blankline")
    end,
  })
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  })
  use({
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("plugins.nvim-web-devicons")
    end,
  })
  use({
    "hoob3rt/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.lualine")
    end,
  })
  use({ "junegunn/fzf.vim", requires = { "junegunn/fzf" } })
  use({
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("plugins.nvim-tree")
    end,
  })
  use({
    "akinsho/bufferline.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("plugins.bufferline")
    end,
  })
  use({
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("plugins.dashboard")
    end,
    requires = { "nvim-tree/nvim-web-devicons" },
  })

  -- Git
  use("APZelos/blamer.nvim")
  use("tpope/vim-fugitive")
  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup()
    end,
  })
  use({
    "ruifm/gitlinker.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitlinker").setup()
    end,
  })

  -- LSP & TreeSitter
  use("neovim/nvim-lspconfig")
  use("kosayoda/nvim-lightbulb")
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/nvim-cmp",
      "hrsh7th/vim-vsnip",
      "nvim-lua/plenary.nvim",
      { "tzachar/cmp-tabnine", run = "./install.sh" },
    },
    config = function()
      require("plugins.nvim-cmp")
    end,
  })
  use({
    "norcalli/snippets.nvim",
    config = function()
      require("snippets").use_suggested_mappings()
    end,
  })
  use({
    "ojroques/nvim-lspfuzzy",
    config = function()
      require("lspfuzzy").setup({})
    end,
  })
  use({
    "onsails/lspkind-nvim",
    config = function()
      require("lspkind").init({})
    end,
  })
  use({
    "nvimdev/lspsaga.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("plugins.lspsaga")
    end,
  })
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- Syntax highlight
  use("darfink/vim-plist")
  --use("sheerun/vim-polyglot")
  use("tmux-plugins/vim-tmux")
  use("udalov/kotlin-vim")

  -- Language support
  use("ap/vim-css-color")
  use("rhysd/vim-clang-format")
  use("wesleimp/stylua.nvim")
  use({ "fatih/vim-go", run = ":GoUpdateBinaries" })
  use({ "prettier/vim-prettier", run = "yarn install" })

  -- DAP
  use({
    "mfussenegger/nvim-dap",
    wants = {
      "nvim-dap-python",
      "nvim-dap-ui",
      "nvim-dap-virtual-text",
    },
    requires = {
      "mfussenegger/nvim-dap-python",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("plugins.nvim-dap").setup()
    end,
  })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
