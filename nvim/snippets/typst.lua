---@diagnostic disable: undefined-global

-- function in_math_mode()
-- 	local tree = vim.treesitter.get_parser():parse()[1]
-- 	local query = vim.treesitter.query.parse("lua", [[(math)]])
-- 	local cursor = vim.treesitter.get_node()
-- 	for id, node, meta in query:iter_captures(tree:root(), 0) do
-- 		if node == cursor then
-- 			print("yes")
-- 		end
-- 	end
-- 	if node then
-- 		print(node:parent():type())
-- 	end
-- end


return {
	-- math modes
	s({ trig = "mt", snippetType = "autosnippet" },
		fmta("$<>$ ", { i(1) })
	),
	s({ trig = "(%d+)", regTrig = true },
		fmta([[
#for i in range(<>) {
	<>
}]], {
			f(function(_, s) return s.captures[1] end),
			i(1)
		})
	),
	s({ trig = "([^%s]+)t", regTrig = true },
		fmta("(<>)^(<>) ", {
			f(function(_, s) return s.captures[1] end),
			i(1)
		})
	),
	s({ trig = "mmt", snippetType = "autosnippet" },
		fmta("$ <> $ ", { i(1) })
	),
}
