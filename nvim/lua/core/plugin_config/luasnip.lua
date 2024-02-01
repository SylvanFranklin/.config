require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/core/snippets/" })
local ls = require("luasnip")
ls.config.setup({
    enable_autosnippets = true,
})

