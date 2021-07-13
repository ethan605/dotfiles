require("packer").startup(function()
  use "wbthomason/packer.nvim"

  -- Common plugins
  use "airblade/vim-rooter"
  --use "codota/tabnine-vim"
  use "easymotion/vim-easymotion"
  use "jiangmiao/auto-pairs"
  use "junegunn/fzf"
  use "junegunn/fzf.vim"
  use "mhinz/vim-startify"
  use "preservim/nerdcommenter"
  use "tpope/vim-surround"
  use "liuchengxu/vista.vim"
  use { "iamcco/markdown-preview.nvim", run = "cd app && npm install" }
  use { "mg979/vim-visual-multi", branch = "master" }

  -- NERDTree
  use "Xuyuanp/nerdtree-git-plugin"
  use {
    "preservim/nerdtree",
    requires = {
      { "ryanoasis/vim-devicons" },
      { "tiagofumo/vim-nerdtree-syntax-highlight" }
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
  use "shumphrey/fugitive-gitlab.vim"
  use "tommcdo/vim-fubitive"
  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb"

  -- UI
  use "Yggdroot/indentLine"
  use "hoob3rt/lualine.nvim"
  use "connorholyday/vim-snazzy"
  use {
    "romgrk/barbar.nvim",
    requires = {
      { "kyazdani42/nvim-web-devicons" }
    }
  }

  -- LSP & TreeSitter
  use "glepnir/lspsaga.nvim"
  use "hrsh7th/nvim-compe"
  use "neovim/nvim-lspconfig"
  use "norcalli/snippets.nvim"
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- Languages support
  use "alampros/vim-styled-jsx"
  use "andreshazard/vim-freemarker"
  use "ap/vim-css-color"
  use "chunkhang/vim-mbsync"
  use "darfink/vim-plist"
  use "editorconfig/editorconfig-vim"
  use "neomutt/neomutt.vim"
  use "niftylettuce/vim-jinja"
  use "nvie/vim-flake8"
  use "wogong/msmtp.vim"
  use { "fatih/vim-go", run = ":GoUpdateBinaries" }
  use { "prettier/vim-prettier", branch = "release/0.x", run = "npm install" }
  use { "styled-components/vim-styled-components", branch = "main" }
end)

require("lualine").setup {
  options = {
    component_separators = "",
    section_separators = "",
    theme = "powerline",
  }
}

require("compe").setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  resolve_timeout = 800,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = {
    border = { "", "" ,"", " ", "", "", "", " " }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  },
  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  }
}
