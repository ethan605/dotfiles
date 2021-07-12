require("packer").startup(function()
  use "wbthomason/packer.nvim"

  -- Common plugins
  use "airblade/vim-rooter"
  use "codota/tabnine-vim"
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
  use "kyazdani42/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"

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
  use "romgrk/barbar.nvim"

  -- Languages support
  use "alampros/vim-styled-jsx"
  use "andreshazard/vim-freemarker"
  use "ap/vim-css-color"
  use "chunkhang/vim-mbsync"
  use "darfink/vim-plist"
  use "editorconfig/editorconfig-vim"
  use "glepnir/lspsaga.nvim"
  use "neomutt/neomutt.vim"
  use "neovim/nvim-lspconfig"
  use "niftylettuce/vim-jinja"
  use "nvie/vim-flake8"
  use "wogong/msmtp.vim"
  use { "fatih/vim-go", run = ":GoUpdateBinaries" }
  use { "prettier/vim-prettier", branch = "release/0.x", run = "npm install" }
  use { "styled-components/vim-styled-components", branch = "main" }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
end)

require("lualine").setup {
  options = {
    component_separators = "",
    section_separators = "",
    theme = "powerline",
  }
}
