require('render-markdown').setup({
    render_modes = true,
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
    code = {
        enabled = true,
        sign = false,
        style = 'normal',
        position = 'inline',
        language_pad = 0,
        language_name = false,
        disable_background = { 'diff' },
        width = 'fill',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = 'thick',
        above = '▄',
        below = '▀',
        highlight = 'RenderMarkdownCode',
        highlight_inline = 'RenderMarkdownCodeInline',
        highlight_language = nil,
    },

    heading = {
        enabled = true,
        sign = true,
        position = 'inline',
        icons = {},
        signs = { '󰫎 ' },
        width = 'full',
        backgrounds = {
            'RenderMarkdownH1Bg',
            'RenderMarkdownH2Bg',
            'RenderMarkdownH3Bg',
            'RenderMarkdownH4Bg',
            'RenderMarkdownH5Bg',
            'RenderMarkdownH6Bg',
        },
        foregrounds = {
            'RenderMarkdownH1',
            'RenderMarkdownH2',
            'RenderMarkdownH3',
            'RenderMarkdownH4',
            'RenderMarkdownH5',
            'RenderMarkdownH6',
        },
    }

})
