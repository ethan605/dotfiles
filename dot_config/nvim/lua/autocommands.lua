-- Performance tweaks for large files
local jsSyntaxGroup = vim.api.nvim_create_augroup("JsSyntaxGroup", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*js", "*.jsx", "*.ts", "*.tsx" },
  command = "syntax sync fromstart",
  group = jsSyntaxGroup,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = { "*js", "*.jsx", "*.ts", "*.tsx" },
  command = "syntax sync clear",
  group = jsSyntaxGroup,
})

-- Auto format
local autoFormatGroup = vim.api.nvim_create_augroup("AutoFormatGroup", { clear = true })

-- Call Stylua on save - using none-ls
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.luau" },
  command = "lua vim.lsp.buf.format()",
  group = autoFormatGroup,
})

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("help_window_right", {}),
  pattern = { "*.txt" },
  callback = function()
    if vim.o.filetype == "help" then vim.cmd.wincmd("L") end
  end,
})

-- Disable nvim-ufo for certain file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "NvimTree",
    "checkhealth",
    "dashboard",
    "help",
    "lazy",
    "lspinfo",
    "mason",
    "null-ls-info",
    "dbui",
    "dbout",
  },
  callback = function()
    require("ufo").detach()
    vim.opt_local.foldenable = false
    vim.opt_local.foldcolumn = "0"
    vim.wo.foldcolumn = "0"
  end,
})

vim.api.nvim_create_user_command(
  "TodoFzf",
  function(args)
    local todoFzf = require("todo-comments.fzf")
    local keyword = args.args

    if string.len(keyword) == 0 then
      todoFzf.todo()
    else
      todoFzf.todo({ keywords = { keyword } })
    end
  end,
  { desc = "Browse Todo comments by keyword", nargs = "?" }
)
