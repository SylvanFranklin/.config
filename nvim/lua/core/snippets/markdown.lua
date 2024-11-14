local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

return {
    -- Warning Admonition
    s({ trig = ";warn", snippetType = "autosnippet" },
        fmt([[
        > [!WARNING]
        > {}
        ]], { i(1) })
    ),

    -- Info Admonition
    s({ trig = ";info", snippetType = "autosnippet" },
        fmt([[
        > [!INFO]
        > {}
        ]], { i(1) })
    ),

    -- Tip Admonition
    s({ trig = ";tip", snippetType = "autosnippet" },
        fmt([[
        > [!TIP]
        > {}
        ]], { i(1) })
    ),

    -- Hint Admonition
    s({ trig = ";hint", snippetType = "autosnippet" },
        fmt([[
        > [!HINT]
        > {}
        ]], { i(1) })
    ),

    -- Note Admonition
    s({ trig = ";note", snippetType = "autosnippet" },
        fmt([[
        > [!NOTE]
        > {}
        ]], { i(1) })
    ),

    -- Danger Admonition
    s({ trig = ";danger", snippetType = "autosnippet" },
        fmt([[
        > [!DANGER]
        > {}
        ]], { i(1) })
    ),

    -- Link Snippet
    s({ trig = ";link", snippetType = "autosnippet" },
        fmta([[[<>](<>)]], { i(1), i(2) })
    ),

    -- Table Snippet
    s({ trig = ";table", snippetType = "autosnippet" },
        fmta([[
        | <> | <> |
        | :----: | :----: |
        | | |
        | | |
        ]], { i(1), i(2) })
    ),

    -- Image Snippet
    s({ trig = ";img", snippetType = "autosnippet" },
        fmt([[![{}]({})]], { i(1), i(2) })
    )
}
