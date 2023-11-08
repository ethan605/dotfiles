vim.opt.autoread = true                           -- Auto reload file from outside changes
vim.opt.autowrite = true                          -- Auto reload file from outside changes
vim.opt.background = "dark"                       -- For dark themes
vim.opt.backup = false                            -- Some LSP servers have issues with backup files
vim.opt.cmdheight = 2                             -- Better display for messages
vim.opt.completeopt = "menuone,noselect"          -- For nvim-compe
vim.opt.conceallevel = 0                          -- Disable markdown conceal
vim.opt.directory = "/tmp"                        -- Location for temporary files
vim.opt.encoding = "UTF-8"                        -- Encoding
vim.opt.errorbells = false                        -- No beeps.
vim.opt.expandtab = true                          -- Insert spaces when TAB is pressed.

vim.opt.hlsearch = true                           -- Highlight searches
vim.opt.hidden = true                             -- Keep buffer history when switching around
vim.opt.ignorecase = true                         -- Search with smart case
vim.opt.incsearch = true                          -- Incremental search
vim.opt.joinspaces = false                        -- Prevents inserting two spaces after punctuation on a join (J)
vim.opt.linespace = 0                             -- Set line-spacing to minimum.
vim.opt.modeline = true                           -- Enable modeline.
vim.opt.modelines = 1                             -- Enable modeline.
vim.opt.number = true                             -- Show hybrid line numbers on the left side.
vim.opt.relativenumber = true                     -- Show hybrid line numbers on the left side.
vim.opt.ruler = true                              -- Show the line and column numbers of the cursor.
vim.opt.scrolloff = 3                             -- Show next 3 lines while scrolling.
vim.opt.shiftwidth = 2                            -- Indentation amount for < and > commands.
vim.opt.showcmd = true                            -- Show (partial) command in status line.
vim.opt.showmatch = true                          -- Show matching brackets.
vim.opt.showmode = true                           -- Show current mode.
vim.opt.sidescrolloff = 5                         -- Show next 5 columns while side-scrolling.
vim.opt.signcolumn = "yes"                        -- always show signcolumns
vim.opt.smartcase = true                          -- Search with smart case
vim.opt.softtabstop = 2                           -- Render TABs using this many spaces.
vim.opt.splitbelow = true                         -- Horizontal split below current.
vim.opt.splitright = true                         -- Vertical split to right of current.
vim.opt.startofline = false                       -- Do not jump to first character with page commands.
vim.opt.swapfile = false                          -- Disable swap files
vim.opt.tabstop = 2                               -- Render TABs using this many spaces.
vim.opt.textwidth = 0                             -- Hard-wrap long lines as you type them.
vim.opt.updatetime = 300                          -- You will have bad experience for diagnostic messages when it's default 4000.
vim.opt.writebackup = false                       -- Some LSP servers have issues with backup files

vim.opt.foldenable = true                         -- Enable code folding
vim.opt.foldlevel = 0
vim.opt.foldlevelstart = 9                        -- Don't fold by default
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"   -- Code folding with tree-sitter

vim.opt.clipboard:append("unnamedplus")           -- Use system clipboard over vim's buffers
vim.opt.formatoptions:append("o")                 -- Continue comment marker in new lines.
vim.opt.showbreak = "⤷ "
vim.opt.listchars = {                             -- Hidden characters
  conceal = "|",
  eol = "¬",
  extends = "…",
  nbsp = "␣",
  precedes = "…",
  tab = "→ ",
  trail = "·",
}
vim.opt.runtimepath:append("/usr/local/opt/fzf")  -- Add fzf to run time path
vim.opt.shortmess:append("c")                     -- don't give 'ins-completion-menu' messages.

-- Configure backups
vim.opt.backupcopy = "yes"
vim.opt.backupdir = "~/tmp,/tmp"
vim.opt.backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*"
