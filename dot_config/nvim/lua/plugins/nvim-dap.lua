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
  require("nvim-dap-virtual-text").setup({
    commented = true,
  })

  local dapui = require("dapui")

  dapui.setup({
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.75,
          },
          {
            id = "breakpoints",
            size = 0.25,
          },
        },
        position = "right",
        size = 75,
      },
      {
        elements = {
          {
            id = "repl",
            size = 1,
          },
        },
        position = "bottom",
        size = 25,
      },
    },
  })
  dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
end

local function configure_python(dap)
  dap.adapters.remote_python = function(callback)
    callback({
      type = "server",
      host = "127.0.0.1",
      port = 5678,
    })
  end

  dap.configurations.python = {
    {
      type = "remote_python",
      request = "attach",
      name = "Remote attach",
      host = "127.0.0.1",
      port = 5678,
    },
  }
end

local function configure_cpp(dap)
  dap.adapters.lldb = {
    type = "executable",
    command = "/opt/homebrew/opt/llvm/bin/lldb-vscode",
    name = "lldb",
  }
  dap.configurations.cpp = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
    },
  }
end

---@type LazySpec
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mfussenegger/nvim-dap-python",
    "nvim-dap-python",
    "nvim-dap-ui",
    "nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    configure()

    local dap = require("dap")
    configure_exts(dap)
    configure_python(dap)
    configure_cpp(dap)
  end,
  keys = function()
    local dap = require("dap")
    local widgets = require("dap.ui.widgets")

    return {
      { "<F5>",       ":DapContinue<CR>" },
      { "<F10>",      ":DapStepOver<CR>" },
      { "<F11>",      ":DapStepInto<CR>" },
      { "<F12>",      ":DapStepOut<CR>" },
      { "<leader>db", ":DapToggleBreakpoint<CR>" },
      { "<leader>dr", ":DapToggleRepl<CR>" },
      {
        "<leader>dl",
        function()
          dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
      },

      -- UI Widgets
      { "<leader>dh", widgets.hover,                                        mode = { "n", "v" } },
      { "<leader>dp", widgets.preview,                                      mode = { "n", "v" } },
      { "<leader>df", function() widgets.centered_float(widgets.frames) end },
      { "<leader>ds", function() widgets.centered_float(widgets.scopes) end },
    }
  end,
}
