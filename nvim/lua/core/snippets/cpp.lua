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


function header_guard()
    local filename = vim.fn.expand("%:t")
    local guard = string.upper(filename:gsub("%.", "_"):gsub("-", "_"))
    return guard
end

return {
    s({ trig = ";header", snippetType = "autosnippet" },
    fmta([[
    #ifndef <>
    #define <>
    <>
    #endif // <>
    ]],
    {
        f(header_guard), f(header_guard), i(1), f(header_guard)
    })
    ),
}