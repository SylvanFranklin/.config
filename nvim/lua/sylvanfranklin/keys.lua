-- general
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", "<CMD>write<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')

function jump_header()
    -- Get the full path of the current file
    -- local file = vim.fn.expand("%:p")
    local ext = vim.fn.expand("%:e")

    -- Define potential source and header file extensions
    local source_exts = { "cpp", "c", "frag", "server.ts" }
    local header_exts = { "h", "hpp", "hh", "vert", "svelte" }

    -- Determine the new extension
    local target_exts = nil
    if vim.tbl_contains(header_exts, ext) then
        target_exts = source_exts
    elseif vim.tbl_contains(source_exts, ext) then
        target_exts = header_exts
    else
        print("Not a recognized C++ header or source file.")
        return
    end

    -- Attempt to find and open the counterpart file
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
vim.keymap.set("n", "<leader>b", ":lua jump_header()<CR>", { silent = true })
