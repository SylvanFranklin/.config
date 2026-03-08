local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(cx.yanked) do
		table.insert(paths, tostring(u))
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

return {
	entry = function()
		local urls = selected_or_hovered()

		if #urls == 0 then
			return ya.notify({ title = "System Clipboard", content = "No file selected", level = "warn", timeout = 5 })
		end

		local cmd = Command("clippy")
		for _, url in ipairs(urls) do
			cmd = cmd:arg(url)
		end

		local output, err = cmd
			:stdout(Command.PIPED)
			:stderr(Command.PIPED)
			:spawn()
			:wait_with_output()

		if err == nil then
			ya.notify({
				title = "Clipboard: Copied " .. tostring(#urls) .. " file(s)",
				content = table.concat(urls, "\n"),
				level = "info",
				timeout = 5,
			})
		end

		if err ~= nil then
			ya.notify({
				title = "Clipboard",
				content = string.format("Could not copy selected file(s): %s", output.stderr),
				level = "error",
				timeout = 5,
			})
		end
	end,
}
