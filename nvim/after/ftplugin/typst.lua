vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", { buffer = 0 })


-- configuration
require("nvim-treesitter-textobjects").setup {
	select = {
		lookahead = true,
		selection_modes = {
			['@math.inner'] = 'v',
			['@math.outer'] = 'V',
		},
		include_surrounding_whitespace = false,
	},
}

-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set({ "x", "o" }, "am", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@math.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "im", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@math.inner", "textobjects")
end)

vim.cmd([[
	"setlocal wrapmargin=10
	"setlocal formatoptions+=t
	"setlocal linebreak
	setlocal spell
	"setlocal wrap
]])
