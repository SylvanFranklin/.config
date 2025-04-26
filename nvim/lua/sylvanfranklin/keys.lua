-- general
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", "<CMD>write<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')

function jump_pair()
    local ext = vim.fn.expand("%:e")
    local source_exts = { "cpp", "c", "frag", "server.ts", "js", "ts", "jsx", "tsx", "py", "java", "rs", "go", "css",
        "scss", "less" }
    local header_exts = { "h", "hpp", "hh", "vert", "svelte", "html", "vue", "component.ts", "component.js", "types.ts",
        "interface.ts", "d.ts", "test.py", "spec.ts", "spec.js", "test.js", "test.ts" }
    local target_exts = nil
    if vim.tbl_contains(header_exts, ext) then
        target_exts = source_exts
    elseif vim.tbl_contains(source_exts, ext) then
        target_exts = header_exts
    else
        print("Not a recognized file pair.")
        return
    end

    local base_name = vim.fn.expand("%:r")
    for _, target_ext in ipairs(target_exts) do
        local target_file = base_name .. "." .. target_ext
        if vim.fn.filereadable(target_file) == 1 then
            vim.cmd("edit " .. target_file)
            return
        end
    end

    print("Corresponding file not found.")
end

-- Key mapping to jump between header and source files
vim.keymap.set("n", "<leader>b", ":lua jump_pair()<CR>", { silent = true })


-- ZenMode keymaps
vim.keymap.set("n", "<leader>u", ":ZenMode <CR>", { silent = true })


local function tree()
    local node = vim.treesitter.get_node()
    local i = 0
    while true do
        print(node:type())
        if (node:type() ~= "code") then
            node = node:parent()
        else
            break
        end

        if i < 10 then
            break
        end
        i = i + 1
    end

    local start_row, start_col, end_row, end_col = node:range()

    vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col - 1 })
    vim.cmd('normal! v') -- start visual mode
    vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col - 1 })

    -- local captures = vim.treesitter.get_captures_at_cursor()
    -- for _, capture in ipairs(captures) do
    --     print(capture)
    -- end
end


vim.keymap.set({ "n", "v" }, "<leader>o", tree, {})
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set({ "n" }, "<leader>R", ":RecordPicker<CR>", { silent = false })
