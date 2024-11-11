require('render-markdown').setup({
    anti_conceal = {
        enabled = true,
        -- Which elements to always show, ignoring anti conceal behavior. Values can either be booleans
        -- to fix the behavior or string lists representing modes where anti conceal behavior will be
        -- ignored. Possible keys are:
        --  head_icon, head_background, head_border, code_language, code_background, code_border
        --  dash, bullet, check_icon, check_scope, quote, table_border, callout, link, sign
        ignore = {
            code_background = true,
            sign = true,
        },
        above = 0,
        below = 0,
    },
})
