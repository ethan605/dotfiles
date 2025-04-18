local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<F5>", ":DapContinue<CR>", opts)
vim.keymap.set("n", "<F10>", ":DapStepOver<CR>", opts)
vim.keymap.set("n", "<F11>", ":DapStepInto<CR>", opts)
vim.keymap.set("n", "<F12>", ":DapStepOut<CR>", opts)
vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", opts)
vim.keymap.set(
  "n",
  "<leader>dl",
  function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
  opts
)
vim.keymap.set("n", "<leader>dr", ":DapToggleRepl<CR>", opts)
--vim.keymap.set("n", "<leader>dl", function() require("dap").run_last() end, opts)

-- nvim-dap-ui widgets
vim.keymap.set({ "n", "v" }, "<leader>dh", function() require("dap.ui.widgets").hover() end, opts)
vim.keymap.set({ "n", "v" }, "<leader>dp", function() require("dap.ui.widgets").preview() end, opts)
vim.keymap.set("n", "<leader>df", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end, opts)
vim.keymap.set("n", "<leader>ds", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end, opts)
