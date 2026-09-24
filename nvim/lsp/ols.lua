local mason_ols = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "ols")
local ols_cmd = vim.fn.executable(mason_ols) == 1 and mason_ols or "ols"

return {
	cmd = { ols_cmd },
	filetypes = { "odin" },
	root_dir = function(bufnr, on_dir)
		local path = vim.api.nvim_buf_get_name(bufnr)
		local root = vim.fs.root(bufnr, { "ols.json", ".git" })

		if not root and path ~= "" then
			root = vim.fs.dirname(path)
		end

		on_dir(root)
	end,
}
