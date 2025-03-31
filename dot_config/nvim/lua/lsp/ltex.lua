---@class vim.lsp.Config
return {
  cmd = { "ltex-ls" },
  filetypes = {
    "bib",
    "org",
    "plaintex",
    "rst",
    "rnoweb",
    "tex",
    "pandoc",
    "quarto",
    "rmd",
    "context",
    "mail",
    "text",
  },
  settings = {
    ltex = {
      language = "en-GB",
    },
  },
}
