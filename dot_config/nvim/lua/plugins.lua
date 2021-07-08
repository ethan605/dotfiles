return require("packer").startup(function()
  use "wbthomason/packer.nvim"

  use "airblade/vim-rooter"
  use "codota/tabnine-vim"
  use "easymotion/vim-easymotion"
  use "jiangmiao/auto-pairs"
  use "junegunn/fzf"
  use "junegunn/fzf.vim"
  use "preservim/nerdcommenter"
  use "tpope/vim-surround"
  use { "iamcco/markdown-preview.nvim", run = "cd app && npm install" }
  use { "mg979/vim-visual-multi", branch = "master" }

  -- NERDTree
  use "Xuyuanp/nerdtree-git-plugin"
  use "kyazdani42/nvim-web-devicons"
  use "preservim/nerdTree"
  use "ryanoasis/vim-devicons"

  -- Git
  use "APZelos/blamer.nvim"
  use "shumphrey/fugitive-gitlab.vim"
  use "tommcdo/vim-fubitive"
  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb"

  -- UI
  use "Yggdroot/indentLine"
  use "bling/vim-airline"
  use "connorholyday/vim-snazzy"
  use "romgrk/barbar.nvim"
  use "vim-airline/vim-airline-themes"

  -- Languages support
  use "neovim/nvim-lspconfig"
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
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
end)
