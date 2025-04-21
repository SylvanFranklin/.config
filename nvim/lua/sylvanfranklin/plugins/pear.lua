return {
    "sylvanfranklin/pear",
    config = function()
        local pear = require("pear")
        vim.keymap.set("n", "<leader>b", function() pear.jump_pair() end, { silent = true })
    end
}
