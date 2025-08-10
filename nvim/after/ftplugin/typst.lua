vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", { buffer = 0 })
vim.keymap.set({ "n", "x", "v" }, "j", "gj", { buffer = 0 })
vim.keymap.set({ "n", "x", "v" }, "k", "gk", { buffer = 0 })

vim.cmd([[
	setlocal wrapmargin=0
	setlocal formatoptions+=t
	setlocal linebreak
	setlocal spell
	setlocal wrap
]])
