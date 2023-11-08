---@diagnostic disable: undefined-global
require("packer").startup(function()
  use "wbthomason/packer.nvim"

  -- Common plugins
  use "airblade/vim-rooter"
  use "alker0/chezmoi.vim"
  use "connorholyday/vim-snazzy"
  use "easymotion/vim-easymotion"
  use "editorconfig/editorconfig-vim"
  use "folke/lsp-colors.nvim"
  use "liuchengxu/vista.vim"
  use "mhinz/vim-startify"
  use "preservim/nerdcommenter"
  use "tpope/vim-surround"
  use { "iamcco/markdown-preview.nvim", run = "cd app && npm install" }
  use { "mg979/vim-visual-multi", branch = "master" }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins.indent-blankline")
    end
  }
  use {
    "windwp/nvim-autopairs",
    config = function ()
      require("plugins.autopairs")
    end
  }
  use {
    "hoob3rt/lualine.nvim",
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require("plugins.lualine")
    end
  }
  use {
    "junegunn/fzf.vim",
    requires = {
      "junegunn/fzf",
      "tpope/vim-fugitive",
    },
  }
  use {
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function ()
      require("plugins.nvim-tree")
    end
  }
  use {
    "akinsho/bufferline.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function ()
      require("plugins.bufferline")
    end
  }

  -- Git
  use "APZelos/blamer.nvim"
  use {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup()
    end
  }
  use {
    "ruifm/gitlinker.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function ()
      require('gitlinker').setup()
    end
  }

  -- LSP & TreeSitter
  use "neovim/nvim-lspconfig"
  use "kosayoda/nvim-lightbulb"
  use {
    "hrsh7th/nvim-compe",
    requires = {
      "hrsh7th/vim-vsnip",
      { "tamago324/compe-zsh", requires = { "nvim-lua/plenary.nvim" } },
      { "tzachar/compe-tabnine", run = "./install.sh" },
    },
    config = function ()
      require("plugins.compe")
    end
  }
  use {
    "norcalli/snippets.nvim",
    config = function()
      require("snippets").use_suggested_mappings()
    end
  }
  use {
    "ojroques/nvim-lspfuzzy",
    config = function()
      require("lspfuzzy").setup {}
    end
  }
  use {
    "onsails/lspkind-nvim",
    config = function()
      require("lspkind").init {}
    end
  }
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- Syntax highlight
  use "darfink/vim-plist"
  use "sheerun/vim-polyglot"
  use "udalov/kotlin-vim"
  use "tmux-plugins/vim-tmux"

  -- Toolings
  use "ap/vim-css-color"
  use "nvie/vim-flake8"
  use { "fatih/vim-go", run = ":GoUpdateBinaries" }
  use { "prettier/vim-prettier", branch = "release/0.x", run = "npm install" }

  -- DAP
  use {
    "mfussenegger/nvim-dap",
    --event = "BufReadPre",
    --module = { "dap" },
    wants = {
      "nvim-dap-python",
      "nvim-dap-ui",
      "nvim-dap-virtual-text"
    },
    requires = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text"
    },
    config = function()
      require("plugins.nvim-dap").setup()
    end
  }
end)
