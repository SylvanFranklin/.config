local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
    -- math modes
    s({ trig = "mt", snippetType = "autosnippet" },
        fmta("$<>$ ", { i(1) })
    ),
    s({ trig = "t" },
        fmta("^(<>) ", { i(1) })
    ),

    s({ trig = "rt", snippetType = "autosnippet" },
        fmta("^(<>) ", { i(1) })
    ),

    s({ trig = "mmt", snippetType = "autosnippet" },
        fmta("$ <> $ ", { i(1) })
    ),

    s({ trig = "iff", snippetType = "autosnippet" },
        fmt("<==>", {})
    ),
    s({ trig = "impl" },
        fmt("==>", {})
    ),

    s({ trig = "mla" },
        fmta([[
        Sylvan Franklin

        #let today = datetime.today()
        #today.display()

        <>
        ]], { i(1) })
    ),
}
