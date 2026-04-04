local homework_dir = vim.fs.normalize(vim.fn.expand("~/.config/homework"))
local buffer_path = vim.fs.normalize(vim.api.nvim_buf_get_name(0))

vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", { buffer = 0 })

if vim.startswith(buffer_path, homework_dir .. "/") then
	vim.api.nvim_buf_create_user_command(0, "Submit", function()
		local current_pdf = vim.fn.expand("%:t:r") .. ".pdf"

		for _, pdf in ipairs(vim.fn.globpath(homework_dir, "*.pdf", false, true)) do
			if vim.fn.fnamemodify(pdf, ":t") ~= current_pdf then
				vim.fn.delete(pdf)
			end
		end

		local ok = pcall(vim.cmd, "make")
		if not ok then
			return
		end

		vim.fn.jobstart({ "open", homework_dir }, { detach = true })
	end, {
		desc = "Compile homework, prune other PDFs, and open the homework folder",
	})

	vim.cmd([[
		cnoreabbrev <buffer> <expr> submit getcmdtype() ==# ':' && getcmdline() ==# 'submit' ? 'Submit' : 'submit'
	]])
end


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
