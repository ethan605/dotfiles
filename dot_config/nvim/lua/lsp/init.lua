local lspconfig = require("lspconfig")
local utils = require("lsp.utils")

function current_python_path()
  local venv_path = nil

  if io.open(".venv", "r") ~= nil then
    venv_path = ".venv"
  else
    local poetry_venv_path = vim.fn.system("poetry env info -p")
    venv_path = string.gsub(poetry_venv_path, "\n", "")
  end

  return venv_path .. "/bin/python"
end

local servers_with_configs = {
  -- Plug-n-Play LSPs
  basedpyright = {
    settings = {
      basedpyright = {
        disableOrganizeImports = true,
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          typeCheckingMode = "standard",
          useLibraryCodeForTypes = true,
        },
      },
      python = {
        pythonPath = current_python_path(),
      },
    },
  },
  docker_compose_language_service = {},
  dockerls = {},
  eslint = {},
  gopls = {},
  html = {},
  jsonls = {},
  -- postgres_lsp = {}, @TODO: to visit later when it's more mature
  tailwindcss = {},
  terraformls = {},
  yamlls = {},

  -- Custom LSPs
  bashls = {
    filetypes = { "zsh", "bash", "sh" },
  },
  diagnosticls = {
    filetypes = { "javascript", "typescript" },
    init_options = {
      linters = {
        eslint = {
          command = "./node_modules/.bin/eslint",
          rootPatterns = { ".eslintrc.js", ".eslintrc", ".git" },
          debounce = 100,
          args = {
            "--stdin",
            "--stdin-filename",
            "%filepath",
            "--format",
            "json",
          },
          sourceName = "eslint",
          parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "[eslint] ${message} [${ruleId}]",
            security = "severity",
          },
          securities = {
            [2] = "error",
            [1] = "warning",
          },
        },
      },
      filetypes = {
        javascript = "eslint",
        typescript = "eslint",
      },
    },
  },
  ltex = {
    settings = {
      ltex = {
        language = "en-GB",
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        hint = {
          enable = true,
        },
        runtime = {
          version = "LuaJIT",
        },
        workspace = {
          library = {
            vim.env.VIMRUNTIME,
          },
        },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        inlayHints = {
          bindingModeHints = {
            enable = false,
          },
          chainingHints = {
            enable = true,
          },
          closingBraceHints = {
            enable = true,
            minLines = 25,
          },
          closureReturnTypeHints = {
            enable = "never",
          },
          lifetimeElisionHints = {
            enable = "never",
            useParameterNames = false,
          },
          maxLength = 25,
          parameterHints = {
            enable = true,
          },
          reborrowHints = {
            enable = "never",
          },
          renderColons = true,
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
        },
      },
    },
  },
  ts_ls = {
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
  },

  --[[ Disabled due to no active usage
  cssls = {},
  denols = {},
  elixirls = {}
  graphql = {},
  jdtls = {},
  kotlin_language_server = {},
  pyright = {},
  solargraph = {},
  vimls = {},

  clangd = {
    cmd = { "/opt/homebrew/opt/llvm/bin/clangd", "--clang-tidy" },
    settings = {
      clangd = {
        InlayHints = {
          Designators = true,
          Enabled = true,
          ParameterNames = true,
          DeducedTypes = true,
        },
        fallbackFlags = { "-std=c++20" },
      },
    },
  },
  pylsp = {
    settings = {
      pylsp = {
        configurationSources = {},
        plugins = {
          autopep8 = { enabled = false },
          flake8 = { enabled = false },
          mccabe = { enabled = false },
          pycodestyle = { enabled = false },
          pyflake = { enabled = false },
          yapf = { enabled = false },

          rope_autoimport = { enabled = false },
          rope_completion = { enabled = false },
        },
      },
    },
  },
  ]]
}

for server, configs in pairs(servers_with_configs) do
  local settings = {
    capabilities = utils.capabilities,
    flags = utils.default_flags,
    on_attach = utils.on_attach,
  }

  -- Merge server configs to settings object
  for k, v in pairs(configs) do
    settings[k] = v
  end

  lspconfig[server].setup(settings)
end

vim.diagnostic.config({
  virtual_text = false, -- for lsp_lines
})
