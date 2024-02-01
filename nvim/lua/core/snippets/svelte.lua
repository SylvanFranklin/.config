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

    s({ trig = "<([%w%p]+)>", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmt([[
        <{}>
            {}
        </{}>
        ]],
            {
                f(function(_, snip) return snip.captures[1] end, {}),
                i(1),
                f(function(_, snip) return snip.captures[1] end, {}),
            })

    ),

}
