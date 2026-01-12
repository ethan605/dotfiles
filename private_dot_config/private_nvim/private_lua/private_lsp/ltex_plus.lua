---@type vim.lsp.Config
return {
  cmd = { "ltex-ls-plus" },
  filetypes = {
    "bib",
    "context",
    "pandoc",
    "plaintex",
    "tex",
    "latex",
  },
  settings = {
    ltex = {
      enabled = {
        "bib",
        "context",
        "pandoc",
        "plaintex",
        "tex",
        "latex",
      },
      language = "en-GB",
    },
  },
}
