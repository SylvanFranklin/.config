return {
    s({ trig = "for" },
        fmta([[
        for i in range(<>):
            <>
        ]],
            {
                i(1),
                i(2),
            })
    ),
}, {
}

-- s({ trig = "<([%w%p]+)>", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
--     fmt([[
--     <{}>
--         {}
--     </{}>
--     ]],
--         {
--             f(function(_, snip) return snip.captures[1] end, {}),
--             i(1),
--             f(function(_, snip) return snip.captures[1] end, {}),
--         })
-- ),
--
-- s({ trig = "#each", regTrig = false, wordTrig = false, snippetType = "autosnippet" },
--     fmta([[
--     {#each <> as <>}
--         <>
--     {/each}
--     ]],
--         {
--             i(1),
--             i(2),
--             i(3),
--         })
-- ),
-- s({ trig = "<ts", regTrig = false, wordTrig = false, snippetType = "autosnippet" },
--     fmt([[
--     <script lang="ts">
--         {}
--     </script>
--     ]],
--         {
--             i(1),
--         })
-- ),
-- s({ trig = "for i", regTrig = false, wordTrig = false, snippetType = "autosnippet" },
--     fmta([[
--     for (let i = 0; i <>; i++) {
--        <>
--     }
--     ]],
--         {
--             i(1),
--             i(2),
--         })
-- ),
-- s({ trig = "fn.", regTrig = false, wordTrig = false, snippetType = "autosnippet" },
--     fmta([[
--     function <>() {
--         <>
--     }
--     ]],
--         {
--             i(1),
--             i(2),
--         })
-- ),
--
-- s({ trig = "#await", regTrig = false, wordTrig = false, snippetType = "autosnippet" },
--     fmta([[
--     {#await <>}
--         <>
--     {:then}
--         <>
--     {:catch}
--         <>
--     {/await}
--     ]],
--         {
--             i(1),
--             i(2),
--             i(3),
--             i(4),
--         })
-- ),
--
-- s({ trig = ":else", regTrig = false, wordTrig = false, snippetType = "autosnippet" },
--     fmta([[
--     {:else <>}
--         <>
--     ]],
--         {
--             i(1),
--             i(2),
--         })
-- ),
-- s({ trig = "#if", regTrig = false, wordTrig = false, snippetType = "autosnippet" },
--     fmta([[
--     {#if <>}
--         <>
--     {/if}
--     ]],
--         {
--             i(1),
--             i(2),
--         })
-- ),
-- }
