local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

return {
    -- Warning Admonition
    s({ trig = "warn" },
        fmt([[
        > [!WARNING]
        > {}
        ]], { i(1) })
    ),

    -- Info Admonition
    s({ trig = "info" },
        fmt([[
        > [!INFO]
        > {}
        ]], { i(1) })
    ),

    -- Tip Admonition
    s({ trig = "tip" },
        fmt([[
        > [!TIP]
        > {}
        ]], { i(1) })
    ),

    -- Hint Admonition
    s({ trig = "hint" },
        fmt([[
        > [!HINT]
        > {}
        ]], { i(1) })
    ),

    -- Note Admonition
    s({ trig = "note" },
        fmt([[
        > [!NOTE]
        > {}
        ]], { i(1) })
    ),

    -- Danger Admonition
    s({ trig = "danger" },
        fmt([[
        > [!DANGER]
        > {}
        ]], { i(1) })
    ),

    -- Link Snippet
    s({ trig = "link" },
        fmta([[[<>](<>)]], { i(1), i(2) })
    ),

    -- Table Snippet
    s({ trig = "table" },
        fmta([[
        | <> | <> |
        | :----: | :----: |
        | | |
        | | |
        ]], { i(1), i(2) })
    ),

    -- Image Snippet
    s({ trig = "img" },
        fmt([[![{}]({})]], { i(1), i(2) })
    ),

    s({ trig = "date" },
        fmt([[{}]], { f(function(_, _)
            return os.date("%Y-%m-%d")
        end) })
    )
}, {}
