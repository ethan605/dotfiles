---@type vim.lsp.Config
return {
  cmd = { "ltex-ls" },
  filetypes = {
    "bib",
    "plaintex",
    "tex",
  },
  settings = {
    ltex = {
      language = "en-GB",
    },
  },
}
