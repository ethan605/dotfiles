---@diagnostic disable: undefined-global
require("packer").startup(function()
  use "wbthomason/packer.nvim"

  -- Common plugins
  use "airblade/vim-rooter"
  use "easymotion/vim-easymotion"
  use "editorconfig/editorconfig-vim"
  use "junegunn/fzf"
  use "junegunn/fzf.vim"
  use "liuchengxu/vista.vim"
  use "mhinz/vim-startify"
  use "preservim/nerdcommenter"
  use "tpope/vim-surround"
  use "windwp/nvim-autopairs"
  use {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup()
    end
  }
  use { "iamcco/markdown-preview.nvim", run = "cd app && npm install" }
  use { "mg979/vim-visual-multi", branch = "master" }

  -- NERDTree
  use "Xuyuanp/nerdtree-git-plugin"
  use {
    "preservim/nerdtree",
    requires = {
      "ryanoasis/vim-devicons",
      "tiagofumo/vim-nerdtree-syntax-highlight",
    }
  }
  --[[ use {
    "kyazdani42/nvim-tree.lua",
    requires = {
      { "kyazdani42/nvim-web-devicons" }
    }
  } ]]

  -- Git
  use "APZelos/blamer.nvim"
  use "tpope/vim-fugitive"
  use {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function ()
      require("gitsigns").setup()
    end
  }
  use {
    "ruifm/gitlinker.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("plugins.gitlinker")
    end
  }

  -- UI
  use "Yggdroot/indentLine"
  use "hoob3rt/lualine.nvim"
  use "connorholyday/vim-snazzy"
  use {
    "romgrk/barbar.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
    }
  }

  -- LSP & TreeSitter
  use "neovim/nvim-lspconfig"
  use "kosayoda/nvim-lightbulb"
  use {
    "hrsh7th/nvim-compe",
    requires = {
      "hrsh7th/vim-vsnip",
      {
        "tamago324/compe-zsh",
        requires = { "nvim-lua/plenary.nvim" },
      },
      { "tzachar/compe-tabnine", run = "./install.sh" },
    }
  }
  use {
    "norcalli/snippets.nvim",
    config = function ()
      require("snippets").use_suggested_mappings()
    end
  }
  use {
    "ojroques/nvim-lspfuzzy",
    requires = {
      "junegunn/fzf",
      "junegunn/fzf.vim",
    },
    config = function ()
      require("lspfuzzy").setup {}
    end
  }
  use {
    "onsails/lspkind-nvim",
    config = function ()
      require("lspkind").init()
    end
  }
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- Syntax highlight
  use "darfink/vim-plist"
  use "sheerun/vim-polyglot"

  -- Toolings
  use "ap/vim-css-color"
  use "nvie/vim-flake8"
  use { "fatih/vim-go", run = ":GoUpdateBinaries" }
  use { "prettier/vim-prettier", branch = "release/0.x", run = "npm install" }
end)

require("plugins.auto-pairs")
require("plugins.compe")
require("plugins.lualine")
