" vim:fileencoding=utf-8:foldenable:foldmethod=marker

" {{{ 1. Plugins
call plug#begin()

Plug '/usr/local/bin/fzf'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'alampros/vim-styled-jsx'
Plug 'andreshazard/vim-freemarker'
Plug 'ap/vim-css-color'
Plug 'bling/vim-airline'
Plug 'chunkhang/vim-mbsync'
Plug 'connorholyday/vim-snazzy'
Plug 'darfink/vim-plist'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'flowtype/vim-flow'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & npm install'  }
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'jiangmiao/auto-pairs'
Plug 'jparise/vim-graphql'
Plug 'junegunn/fzf.vim'
Plug 'kevinoid/vim-jsonc'
Plug 'mattn/emmet-vim'
Plug 'mkitt/tabline.vim'
Plug 'neomutt/neomutt.vim'
Plug 'niftylettuce/vim-jinja'
Plug 'nvie/vim-flake8'
Plug 'pangloss/vim-javascript'
Plug 'peitalin/vim-jsx-typescript'
Plug 'preservim/nerdTree'
Plug 'preservim/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'terryma/vim-multiple-cursors'
Plug 'tommcdo/vim-fubitive'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline-themes'
Plug 'voldikss/vim-floaterm'
Plug 'wogong/msmtp.vim'

if has('nvim')
  Plug 'APZelos/blamer.nvim'
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
endif

call plug#end()
" }}}

" {{{ 2. Variables

" Disable unused providers
let g:loaded_python_provider = 0
let g:loaded_perl_provider = 0

" Disable typescript from vim-polyglot
" in favour of peitalin/vim-jsx-typescript
" let g:polyglot_disabled = ['typescript']

" For vim-airline
let g:airline_theme = 'powerlineish'
let g:airline_powerline_fonts = 1

" For vim-flow
let g:flow#enable = 0

" For vim-go
let g:go_fmt_autosave = 1
let g:go_imports_autosave = 1
let g:go_metalinter_autosave = 1
let g:go_mod_fmt_autosave = 1

" For indentLine
let g:indentLine_char = '·'
let g:indentLine_enabled = 1

" For NERDTree
let g:NERDSpaceDelims = 1 
let g:NERDTreeIgnore = ['\~$', 'node_modules']

" For material-monokai
let g:materialmonokai_italic = 1
let g:materialmonokai_subtle_airline = 1
let g:materialmonokai_subtle_spell = 1

" For markdown-preview
let g:mkdp_preview_options = {
  \ 'maid': { 'sequence': { 'showSequenceNumbers': 'true' } },
  \ }

" Show hidden files in NERDTree
let NERDTreeShowHidden = 1

" For vim-fugitive
let g:fugitive_gitlab_domains = ['https://gitlab.eu-west-1.mgmt.onfido.xyz/']

" For vim-go
let g:go_doc_keywordprg_enabled = 0

if has('nvim')
  " For blamer.nvim
  let g:blamer_delay = 500
  let g:blamer_enabled = 1
  let g:blamer_show_in_visual_modes = 0
  let g:blamer_template = '<author>, <author-time> • <summary>'

  " For coc.nvim
  let g:coc_global_extensions = [
    \ 'coc-deno',
    \ 'coc-elixir',
    \ 'coc-eslint',
    \ 'coc-go',
    \ 'coc-html',
    \ 'coc-java',
    \ 'coc-json',
    \ 'coc-kotlin',
    \ 'coc-prettier',
    \ 'coc-snippets',
    \ 'coc-solargraph',
    \ 'coc-swagger',
    \ 'coc-tabnine'
    \ ]
  let g:coc_snippet_next = '<c-j>'
  let g:coc_snippet_prev = '<c-k>'
endif

if !has('nvim')
  let g:NERDTreeGitStatusConcealBrackets = 1
endif
" }}}

" {{{ 3. Settings
set autoread                " Auto reload file from outside changes
set autowrite               " Auto reload file from outside changes
set background=dark         " For dark themes
set clipboard+=unnamedplus  " Use system clipboard over vim's buffers
set cmdheight=2             " Better display for messages
set conceallevel=0          " Disable markdown conceal
set directory=/tmp          " Location for temporary files
set encoding=UTF-8          " Encoding
set expandtab               " Insert spaces when TAB is pressed.
set foldenable					    " Enable code folding
set foldmethod=marker       " Using marker to fold by default
set formatoptions+=o        " Continue comment marker in new lines.
set hlsearch                " Highlight searches
set ignorecase              " Search with smart case
set incsearch               " Incremental search
set linespace=0             " Set line-spacing to minimum.
set listchars+=eol:¬        " Hidden characters
set modeline                " Enable modeline.
set modelines=1             " Enable modeline.
set nobackup                " Some LSP servers have issues with backup files
set noerrorbells            " No beeps.
set nofoldenable			" Not folding by default
set nojoinspaces            " Prevents inserting two spaces after punctuation on a join (J)
set nostartofline           " Do not jump to first character with page commands.
set noswapfile              " Disable swap files
set nowritebackup           " Some LSP servers have issues with backup files
set number relativenumber   " Show hybrid line numbers on the left side.
set ruler                   " Show the line and column numbers of the cursor.
set scrolloff=3             " Show next 3 lines while scrolling.
set shiftwidth=2            " Indentation amount for < and > commands.
set shortmess+=c            " don't give 'ins-completion-menu' messages.
set showcmd                 " Show (partial) command in status line.
set showmatch               " Show matching brackets.
set showmode                " Show current mode.
set sidescrolloff=5         " Show next 5 columns while side-scrolling.
set signcolumn=yes          " always show signcolumns
set smartcase               " Search with smart case
set softtabstop=2           " Render TABs using this many spaces.
set splitbelow              " Horizontal split below current.
set splitright              " Vertical split to right of current.
set tabstop=2               " Render TABs using this many spaces.
set textwidth=0             " Hard-wrap long lines as you type them.
set updatetime=300          " You will have bad experience for diagnostic messages when it's default 4000.

" Configure backups
set backupcopy=yes
set backupdir=~/tmp,/tmp
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*

" Add fzf to run time path
set runtimepath+=/usr/local/opt/fzf 
" }}}

" {{{ 4. Color scheme
filetype plugin on
syntax on
set termguicolors
colorscheme snazzy

if !has('nvim')
  " Configure special characters
  set t_ZH=[3m
  set t_ZR=[23m
endif
" }}}

" {{{ 5. Highlight colors
" Line limit column colors
hi ColorColumn      guibg=gray            guifg=fg 

" TabLine highlight colors
hi TabLine          gui=none              guibg=bg        guifg=white
hi TabLineFill      gui=none              guibg=bg
hi TabLineSel       gui=bold,inverse

if has('nvim')
  " coc.nvim
  hi CocUnderline     cterm=undercurl     gui=undercurl

  hi SpellBad         gui=undercurl       guibg=none      guifg=lightred
  hi SpellCap         gui=undercurl       guibg=none      guifg=lightred
  hi SpellLocal       gui=undercurl       guibg=none      guifg=lightred
  hi SpellRare        gui=undercurl       guibg=none      guifg=lightred

  " Matched parentheses colors
  hi MatchParen       gui=bold            guibg=none      guifg=#ff6ac1
endif

if !has('nvim')
  hi Visual           ctermbg=white       ctermfg=black

  " Matched parentheses colors
  hi MatchParen       cterm=bold          ctermbg=none    ctermfg=magenta

  hi clear            SignColumn
endif
" }}}

" {{{ 6.Custom functions
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:smarter_NERDTreeToggle()
  if &filetype == 'nerdtree'
    :NERDTreeToggle
  else
    :NERDTreeFind
  endif
endfunction

if has('nvim')
  function! s:select_current_word()
    if !get(g:, 'coc_cursors_activated', 0)
      return "\<Plug>(coc-cursors-word)"
    endif
    return "*\<Plug>(coc-cursors-word):nohlsearch\<cr>"
  endfunc

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
endif
" }}}

" {{{ 7. Remaps
" Toggle NERDTree with focusing current file's location
nmap <silent> <c-o> :call <sid>smarter_NERDTreeToggle()<cr>

" Quick files opening
nmap <silent> <c-p> :GFiles<cr>
nmap <silent> <c-g> :GFiles?<cr>

" Copy current file's path
nmap <silent> ycf :let @+=@%<cr>

" Easymotion prefix
nmap <silent> <leader> <Plug>(easymotion-prefix)

" Leader + space to hide search highlights
nmap <silent> <leader><space> :nohlsearch<cr>

if has('nvim')
  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <silent><expr> <tab>
    \ pumvisible() ? "\<c-n>" :
    \ <sid>check_back_space() ? "\<tab>" :
    \ coc#refresh()
  inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<c-h>"

  " Use <c-c> to trigger completion.
  inoremap <silent><expr> <c-c> coc#refresh()

  " Use <c-space> to confirm completion
  inoremap <expr> <c-space> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"

  " Use <c-l> for trigger snippet expand.
  imap <c-l> <Plug>(coc-snippets-expand)

  " Use <c-j> for select text for visual placeholder of snippet.
  vmap <c-j> <Plug>(coc-snippets-select)

  " Use <c-j> for both expand and jump (make expand higher priority.)
  imap <c-j> <Plug>(coc-snippets-expand-jump)

  " coc.nvim gotos
  nmap <silent> gd :call CocAction('jumpDefinition', 'tab drop')<cr>
  " nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " coc-eslint jumps
  nmap <silent> ]w <Plug>(coc-diagnostic-next)
  nmap <silent> [w <Plug>(coc-diagnostic-prev)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <sid>show_documentation()<cr>

  " Search globally with RipGrep
  nmap <c-s> :Rg<space>
endif
" }}}

" {{{ 8. Auto commands
" Performance tweaks for large files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

augroup javascript_folding
  autocmd!
  autocmd FileType javascript setlocal foldmethod=syntax
augroup END

" Disable unnecessary conceals for markdowns
augroup markdown_concealing
  autocmd!
  autocmd FileType markdown let g:indentLine_enabled=0
  autocmd FileType markdown set conceallevel=0
augroup END

" Force syntax highlight for specific file types
autocmd BufNewFile,BufRead vifmrc set syntax=vim
autocmd BufNewFile,BufRead .prettierrc set syntax=json

autocmd BufWritePost *.py call flake8#Flake8()

" Autofix for Prettier on save
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
" }}}

" {{{ 9. Misc
" Show a mark for characters at column 100
call matchadd('ColorColumn', '\%120v', 120)
" }}}
