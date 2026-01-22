---@diagnostic disable: undefined-global

return {
	-- math modes
	s({ trig = "mt", snippetType = "autosnippet" },
		fmta("$<>$ ", { i(1) })
	),
	s({ trig = "mmt", snippetType = "autosnippet" },
		fmta("$ <> $ ", { i(1) })
	),
	s({ trig = "i" },
		fmt("==>", {})
	),
	s({ trig = "cent" },
		fmta("#align(center)[<>]", { i(1) })
	),
	s({ trig = "p" },
		fmta([[_Proof_: $quad$ <>

		]], { i(1) })
	),
	s({ trig = "pi" },
		fmta([[
_Proof_: We use induction on $n$. \
Base case: For $n=1$, $<>$ \
Inductive Step: Suppose now as inductive hypothesis that $<>$. Then since <>
		]], { i(1), i(2), i(3) })
	),
	s({ trig = "v" },
		fmta("#let <> = <>", { i(1), i(2) })
	),
	s({ trig = "f" },
		fmta([[
#let <> = (<>) = {
	<>
}]], { i(1), i(2), i(3) })
	),
}
