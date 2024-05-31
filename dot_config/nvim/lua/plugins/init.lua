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

  -- Vimscript plugins - WIP to replace with Lua alternatives
  use("airblade/vim-rooter")
  use("connorholyday/vim-snazzy")
  use("darfink/vim-plist")
  use("easymotion/vim-easymotion")
  use({ "liuchengxu/vista.vim", requires = { "junegunn/fzf" } })
  use("mg979/vim-visual-multi")
  use({ "prettier/vim-prettier", run = "yarn install --frozen-lockfile --production" })

  -- Common plugins
  use({
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("plugins.nvim-highlight-colors")
    end,
  })
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("plugins.comment")
    end,
  })
  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  })
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  })
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
  use({
    "ibhagwan/fzf-lua",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.fzf-lua")
    end,
  })
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
  use({
    "f-person/git-blame.nvim",
    config = function()
      require("plugins.git-blame")
    end,
  })
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
  use({
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true },
      })
    end,
  })
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/nvim-cmp",
      "hrsh7th/vim-vsnip", -- for Vim commands
      "nvim-lua/plenary.nvim",
      "onsails/lspkind-nvim", -- for LSP pictograms
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
    "nvimdev/lspsaga.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("plugins.lspsaga")
    end,
  })
  use({
    "linrongbin16/lsp-progress.nvim",
    config = function()
      require("plugins.lsp-progress")
    end,
  })
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- Language support
  use("wesleimp/stylua.nvim")

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
