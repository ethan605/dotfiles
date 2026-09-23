---@return table<string>
local function get_cmd()
  local ts7_cmd = { "tsc", "--lsp", "--stdio" }
  local tsserver_cmd = { "typescript-language-server", "--stdio" }

  if vim.fn.executable("tsc") == 1 then
    local result = vim.system(ts7_cmd, { text = true }):wait(200)

    if result.code == 0 then
      return ts7_cmd
    end
  end

  return tsserver_cmd
end

---@type vim.lsp.Config
return {
  cmd = get_cmd(),
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  init_options = { hostInfo = "neovim" },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}
