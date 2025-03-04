require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/core/snippets/" })
local ls = require("luasnip")


-- vim.keymap.set({ "i" }, "<C->", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })

-- vim.keymap.set({ "i", "s" }, "<C-e>", function()
--     if ls.choice_active() then
--         ls.change_choice(1)
--     end
-- end, { silent = true })

ls.config.setup({
    enable_autosnippets = true,
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave'
})
