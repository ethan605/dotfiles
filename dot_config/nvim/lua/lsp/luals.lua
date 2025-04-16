---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
  },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      format = {
        enable = true,
        defaultConfig = {
          align_call_args = "false",
          align_function_params = "true",
          call_arg_parentheses = "keep",
          indent_size = "2",
          indent_style = "space",
          max_line_length = "120",
          quote_style = "double",
          space_around_table_field_list = "true",
          space_before_attribute = "true",
          trailing_table_separator = "smart",
        },
      },
      hint = {
        enable = true,
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "$XDG_DATA_HOME/nvim/lazy",
        },
      },
    },
  },
}
