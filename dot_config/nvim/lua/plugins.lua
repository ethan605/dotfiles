return require("packer").startup(function()
  use 'wbthomason/packer.nvim'

  use "airblade/vim-rooter"
  use "easymotion/vim-easymotion"
  use "jiangmiao/auto-pairs"
  use "junegunn/fzf"
  use "junegunn/fzf.vim"
  use "preservim/nerdcommenter"
  use "tpope/vim-surround"
  -- use "voldikss/vim-floaterm"
  use { "iamcco/markdown-preview.nvim", run = "cd app && npm install" }
  use { "mg979/vim-visual-multi", branch = "master" }

  -- NERDTree
  use "Xuyuanp/nerdtree-git-plugin"
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
  use "vim-airline/vim-airline-themes"

  -- Languages support
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- use "alampros/vim-styled-jsx"
  -- use "andreshazard/vim-freemarker"
  -- use "ap/vim-css-color"
  -- use "chunkhang/vim-mbsync"
  -- use "darfink/vim-plist"
  -- use "editorconfig/editorconfig-vim"
  -- use "flowtype/vim-flow"
  -- use "jeffkreeftmeijer/vim-numbertoggle"
  -- use "jparise/vim-graphql"
  -- use "kevinoid/vim-jsonc"
  -- use "mattn/emmet-vim"
  -- use "mkitt/tabline.vim"
  -- use "neomutt/neomutt.vim"
  -- use "niftylettuce/vim-jinja"
  use "nvie/vim-flake8"
  -- use "pangloss/vim-javascript"
  -- use "peitalin/vim-jsx-typescript"
  -- use "sheerun/vim-polyglot"
  -- use "shumphrey/fugitive-gitlab.vim"
  -- use "wogong/msmtp.vim"
  use { "fatih/vim-go", run = ":GoUpdateBinaries" }
  use { "styled-components/vim-styled-components", branch = "main" }
end)

