require("nvim-dap-virtual-text").setup()

local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.keymap.set({ 'n' }, '<Leader>d', ':DapViewToggle<CR>')
vim.keymap.set({ 'n', 'i' }, '<leader>db', ':Debug<CR>')
vim.keymap.set({ 'n', 'i' }, '<C-b>', ':DapToggleBreakpoint<CR>')
