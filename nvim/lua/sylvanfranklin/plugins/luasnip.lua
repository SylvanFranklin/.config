return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
        require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/sylvanfranklin/snippets/" })

        local ls = require("luasnip")
        vim.keymap.set({ "i" }, "<C-e>", function() ls.expand() end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })
        ls.config.setup({
            enable_autosnippets = true,
            region_check_events = 'InsertEnter',
            delete_check_events = 'InsertLeave'
        })
    end
}
