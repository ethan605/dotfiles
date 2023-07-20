local M = {}

local function configure()
  local signs = {
    breakpoint = {
      text = "🔴",
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
    },
    rejected = {
      text = "🚫",
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = "🛑",
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }

  vim.fn.sign_define("DapBreakpoint", signs.breakpoint)
  vim.fn.sign_define("DapStopped", signs.stopped)
  vim.fn.sign_define("DapBreakpointRejected", signs.rejected)
end

local function configure_exts(dap)
  require("nvim-dap-virtual-text").setup {
    commented = true
  }

  local dapui = require("dapui")

  dapui.setup {
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.75
          },
          {
            id = "breakpoints",
            size = 0.25
          }
        },
        position = "right",
        size = 75
      },
      {
        elements = {
          {
            id = "repl",
            size = 1
          }
        },
        position = "bottom",
        size = 50
      }
    }
  }
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

local function configure_python(dap)
  dap.adapters.remote_python = function(callback)
    callback({
        type = "server",
        host = "127.0.0.1",
        port = 5678
      })
  end

  dap.configurations.python = {
    {
      type = "remote_python",
      request = "attach",
      name = "Remote attach",
      host = "127.0.0.1",
      port = 5678
    }
  }
end

function M.setup()
  local dap = require('dap')
  configure()
  configure_exts(dap)
  configure_python(dap)
end

return M
