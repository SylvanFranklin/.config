local function export(args)
    local export_types = { "pdf", "png", "svg", "html" }
    local target

    if vim.tbl_contains(export_types, args[1]) then
        target = args[1]
    elseif args[1] == nil then
        target = "pdf"
    else
        print("Unsupported filetype. Use 'pdf' or 'png'.")
        return
    end
    local filetype = vim.bo.filetype
    if filetype ~= "typst" then
        print("Current buffer is not a typst file")
        return
    end
    local current_file = vim.fn.expand("%:p")
    local cmd = "typst compile --format " .. target .. " " .. current_file
    print("Running: " .. cmd)
    local result = vim.fn.system(cmd)
    local exit_code = vim.v.shell_error
    if exit_code ~= 0 then
        print("Typst compilation failed: " .. result)
    else
        print("Successfully exported to " .. target)
    end
end

vim.api.nvim_create_user_command("Export", export, {
    nargs = "?",
    complete = function()
        return export_types
    end
})
