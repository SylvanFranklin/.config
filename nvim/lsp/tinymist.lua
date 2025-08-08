local function create_tinymist_command(command_name, client, bufnr)
	local cmd_display = command_name:match 'tinymist%.export(%w+)'
	local function run_tinymist_command()
		local arguments = { vim.api.nvim_buf_get_name(bufnr) }
		return client:exec_cmd({
			title = "Export " .. cmd_display,
			command = command_name,
			arguments = arguments,
		}, { bufnr = bufnr })
	end
	return run_tinymist_command, ('Export' .. cmd_display), ('Export to ' .. cmd_display)
end

return {
	cmd = { 'tinymist' },
	filetypes = { 'typst' },
	root_markers = { '.git' },
	settings = {
		formatterMode = "typstyle"
	},
	on_attach = function(client, bufnr)
		for _, command in ipairs {
			'tinymist.exportSvg',
			'tinymist.exportPng',
			'tinymist.exportPdf',
			'tinymist.exportHtml',
			'tinymist.exportMarkdown',
			-- 'tinymist.exportText',
			-- 'tinymist.exportQuery',
			-- 'tinymist.exportAnsiHighlight',
		} do
			local cmd_func, cmd_name, cmd_desc = create_tinymist_command(command, client, bufnr)
			vim.api.nvim_buf_create_user_command(bufnr, cmd_name, cmd_func, { nargs = 0, desc = cmd_desc })
		end
	end,
}
