---@diagnostic disable: undefined-global

return {
	s({ trig = "each" },
		fmta([[
        {#each <> as <>}
            <>
        {/each}
        ]],
			{
				i(1),
				i(2),
				i(3),
			})
	),
	s({ trig = "if" },
		fmta([[
        {#if <>}
            <>
        {/if}
        ]],
			{
				i(1),
				i(2),
			})
	),
	s({ trig = "elif" },
		fmta([[
        {:else if}
            <>
        ]],
			{
				i(1),
			})
	),
	s({ trig = "else" },
		fmta([[
        {:else}
            <>
        ]],
			{
				i(1),
			})
	),
	s({ trig = "ts" },
		fmt([[
        <script lang="ts">
           {}
        </script>
        ]],
			{
				i(1)
			})
	),
	-- s({ trig = "(.+)", regTrig = true },
	-- 	fmt([[
	--        <{}>
	--           {}
	--        </{}>
	--        ]],
	-- 		{
	-- 			f(function(_, s) return s.captures[1] end),
	-- 			i(1),
	-- 			f(function(_, s) return s.captures[1] end)
	-- 		})
	-- ),
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
