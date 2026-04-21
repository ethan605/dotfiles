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

-- Auto format on save
local autoFormatGroup = vim.api.nvim_create_augroup("AutoFormatGroup", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.luau", "*.nix" },
  callback = function() vim.lsp.buf.format() end,
  group = autoFormatGroup,
})

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = { "*.txt" },
  callback = function()
    if vim.o.filetype == "help" then
      vim.cmd.wincmd("L")
    end
  end,
})

-- Auto syntax
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { ".envrc" },
  callback = function() vim.bo.syntax = "sh" end,
})

-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "bash",
    "cmake",
    "comment",
    "cpp",
    "go",
    "gosum",
    "java",
    "javascript",
    "javascriptreact",
    "json",
    "json5",
    "make",
    "nix",
    "python",
    "rust",
    "scala",
    "sh",
    "terraform",
    "typescript",
    "typescriptreact",
    "yaml",
    "yaml.docker-compose",
    "zsh",
  },
  callback = function() vim.treesitter.start() end,
})

-- Auto CSV/TSV view
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv", "tsv" },
  command = "CsvViewEnable",
})

-- Disable nvim-ufo for certain file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "NvimTree",
    "checkhealth",
    "dashboard",
    "dbout",
    "dbui",
    "help",
    "lazy",
    "lspinfo",
    "mason",
    "null-ls-info",
  },
  callback = function()
    require("ufo").detach()
    vim.opt_local.foldenable = false
    vim.opt_local.foldcolumn = "0"
    vim.wo.foldcolumn = "0"
  end,
})

-- For todo-comments.nvim
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
