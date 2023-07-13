local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<F5>", ":DapContinue<CR>", opts)
vim.keymap.set("n", "<F10>", ":DapStepOver<CR>", opts)
vim.keymap.set("n", "<F11>", ":DapStepInto<CR>", opts)
vim.keymap.set("n", "<F12>", ":DapStepOut<CR>", opts)
vim.keymap.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>", opts)
vim.keymap.set("n", "<Leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, opts)
vim.keymap.set("n", "<Leader>dr", ":DapToggleRepl<CR>", opts)
--vim.keymap.set("n", "<Leader>dl", function() require("dap").run_last() end, opts)

-- nvim-dap-ui widgets
vim.keymap.set({"n", "v"}, "<Leader>dh", function() require("dap.ui.widgets").hover() end, opts)
vim.keymap.set({"n", "v"}, "<Leader>dp", function() require("dap.ui.widgets").preview() end, opts)
vim.keymap.set("n", "<Leader>df", function()
  local widgets = require("dap.ui.widgets");
  widgets.centered_float(widgets.frames);
end, opts)
vim.keymap.set("n", "<Leader>ds", function()
  local widgets = require("dap.ui.widgets");
  widgets.centered_float(widgets.scopes);
end, opts)
