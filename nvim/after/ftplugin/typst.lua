vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", { buffer = 0 })





vim.cmd([[
	setlocal wrapmargin=10
	setlocal formatoptions+=t
	setlocal linebreak
	setlocal spell
	setlocal wrap
]])
