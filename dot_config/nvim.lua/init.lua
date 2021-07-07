-- vim:fileencoding=utf-8:foldenable:foldmethod=marker

-- {{{ Plugins
require "paq" {
  "savq/paq-nvim";

  -- General plugins
  "APZelos/blamer.nvim";
  "Yggdroot/indentLine";
  "bling/vim-airline";
  "connorholyday/vim-snazzy";
  "easymotion/vim-easymotion";
  "junegunn/fzf";
  "junegunn/fzf.vim";
  "preservim/nerdTree";
  "preservim/nerdcommenter";
  "ryanoasis/vim-devicons";
  "shumphrey/fugitive-gitlab.vim";
  "tpope/vim-fugitive";
  "tpope/vim-rhubarb";
  "tpope/vim-surround";
  "vim-airline/vim-airline-themes";

  -- { "iamcco/markdown-preview.nvim", run = "cd app && npm install" };
  { "mg979/vim-visual-multi", branch = "master" };

  -- Languages support
  -- "hrsh7th/nvim-compe";
  -- "neovim/nvim-lspconfig";
  -- {"lervag/vimtex", opt=true};
}
-- }}}

-- {{{ Settings
vim.opt.autoread = true                   -- Auto reload file from outside changes
vim.opt.autowrite = true                  -- Auto reload file from outside changes
vim.opt.background = "dark"               -- For dark themes
vim.opt.backup = false                    -- Some LSP servers have issues with backup files
vim.opt.cmdheight = 2                     -- Better display for messages
vim.opt.conceallevel = 0                  -- Disable markdown conceal
vim.opt.directory = "/tmp"                -- Location for temporary files
vim.opt.encoding = "UTF-8"                -- Encoding
vim.opt.errorbells = false                -- No beeps.
vim.opt.expandtab = true                  -- Insert spaces when TAB is pressed.
vim.opt.foldenable = false			          -- Not folding by default
vim.opt.foldenable = true					        -- Enable code folding
vim.opt.foldmethod = "marker"             -- Using marker to fold by default
vim.opt.hlsearch = true                   -- Highlight searches
vim.opt.ignorecase = true                 -- Search with smart case
vim.opt.incsearch = true                  -- Incremental search
vim.opt.joinspaces = false                -- Prevents inserting two spaces after punctuation on a join (J)
vim.opt.linespace = 0                     -- Set line-spacing to minimum.
vim.opt.modeline = true                   -- Enable modeline.
vim.opt.modelines = 1                     -- Enable modeline.
vim.opt.number = true                     -- Show hybrid line numbers on the left side.
vim.opt.relativenumber = true             -- Show hybrid line numbers on the left side.
vim.opt.ruler = true                      -- Show the line and column numbers of the cursor.
vim.opt.scrolloff = 3                     -- Show next 3 lines while scrolling.
vim.opt.shiftwidth = 2                    -- Indentation amount for < and > commands.
vim.opt.showcmd = true                    -- Show (partial) command in status line.
vim.opt.showmatch = true                  -- Show matching brackets.
vim.opt.showmode = true                   -- Show current mode.
vim.opt.sidescrolloff = 5                 -- Show next 5 columns while side-scrolling.
vim.opt.signcolumn = "yes"                -- always show signcolumns
vim.opt.smartcase = true                  -- Search with smart case
vim.opt.softtabstop = 2                   -- Render TABs using this many spaces.
vim.opt.splitbelow = true                 -- Horizontal split below current.
vim.opt.splitright = true                 -- Vertical split to right of current.
vim.opt.startofline = false               -- Do not jump to first character with page commands.
vim.opt.swapfile = false                  -- Disable swap files
vim.opt.tabstop = 2                       -- Render TABs using this many spaces.
vim.opt.textwidth = 0                     -- Hard-wrap long lines as you type them.
vim.opt.updatetime = 300                  -- You will have bad experience for diagnostic messages when it's default 4000.
vim.opt.writebackup = false               -- Some LSP servers have issues with backup files

vim.opt.clipboard:append("unnamedplus")           -- Use system clipboard over vim's buffers
vim.opt.formatoptions:append("o")                 -- Continue comment marker in new lines.
vim.opt.listchars = { eol = "¬" }                 -- Hidden characters
vim.opt.runtimepath:append("/usr/local/opt/fzf")  -- Add fzf to run time path
vim.opt.shortmess:append("c")                     -- don't give 'ins-completion-menu' messages.

-- Configure backups
vim.opt.backupcopy = "yes"
vim.opt.backupdir = "~/tmp,/tmp"
vim.opt.backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*"
-- }}}

-- {{{ Variables
-- Nvim providers
vim.g.loaded_python_provider = false
vim.g.loaded_perl_provider = false

-- For blamer.nvim
vim.g.blamer_delay = 500
vim.g.blamer_enabled = true
vim.g.blamer_show_in_visual_modes = false
vim.g.blamer_template = "<author>, <author-time> • <summary>"

-- For indentLine
vim.g.indentLine_char = "·"
vim.g.indentLine_enabled = true

-- For NERDTree
vim.g.NERDSpaceDelims = true
vim.g.NERDTreeIgnore = { "\\~$", "node_modules" }
vim.g.NERDTreeShowHidden = true

-- For vim-airline
vim.g.airline_theme = "powerlineish"
vim.g.airline_powerline_fonts = true

-- For vim-fugitive
vim.g.fugitive_gitlab_domains = { "https://gitlab.eu-west-1.mgmt.onfido.xyz/" }

-- For vim-go
vim.g.go_doc_keywordprg_enabled = false
vim.g.go_fmt_autosave = true
vim.g.go_imports_autosave = true
vim.g.go_metalinter_autosave = true
vim.g.go_mod_fmt_autosave = true
-- }}}

-- {{{ Color scheme
vim.cmd [[filetype plugin on]]
vim.cmd [[syntax on]]
vim.cmd [[set termguicolors]]
vim.cmd [[colorscheme snazzy]]

-- Line limit column colors
vim.cmd [[hi ColorColumn  guibg=gray  guifg=fg]]

-- TabLine highlight colors
vim.cmd [[hi TabLine      gui=none          guibg=bg  guifg=white]]
vim.cmd [[hi TabLineFill  gui=none          guibg=bg]]
vim.cmd [[hi TabLineSel   gui=bold,inverse]]

-- Matched parentheses colors
vim.cmd [[hi MatchParen   gui=bold  guibg=none  guifg=#ff6ac1]]

-- Show a mark for characters at column 120
vim.cmd [[call matchadd("ColorColumn", "\%120v", 120)]]
-- }}}
