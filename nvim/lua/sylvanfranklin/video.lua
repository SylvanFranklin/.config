local function aesthetic_record()
    local current_file = vim.fn.expand("%:t")
    local time = os.date("%H-%M")
    local output_filename = string.format('%s(%s).mp4', current_file, time)
    local full_path = vim.fn.expand("~/Movies/") .. output_filename

    local cmd = string.format(
        [[ffmpeg -y -f avfoundation -r 30 -i "3:none" -filter:v "crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=5:5:1.0:5:5:0.0" -preset ultrafast "%s"]],
        full_path
    )

    print("Recording to: " .. full_path)

    local job_id = vim.fn.jobstart(cmd, { detach = true })
    vim.g.recording_job_id = job_id
end

local function aesthetic_screenshot()
    local current_file = vim.fn.expand("%:t")
    local time = os.date("%H-%M")
    local output_filename = string.format('%s(%s).png', current_file, time)
    local full_path = vim.fn.expand("~/Pictures/") .. output_filename

    local cmd = string.format(
        [[ffmpeg -y -f avfoundation -frames:v 1 -i "3" -filter:v "crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=5:5:1.0:5:5:0.0" "%s"]],
        full_path
    )


    local result = vim.fn.system(cmd)
    local exit_code = vim.v.shell_error

    if exit_code ~= 0 then
        vim.notify("Failed to take screenshot:\n" .. result, vim.log.levels.ERROR)
    else
        vim.notify("Screenshot saved to: " .. full_path, vim.log.levels.INFO)
    end
end



local function aesthetic_record_hq()
    local current_file = vim.fn.expand("%:t")
    local time = os.date("%H-%M")
    local output_filename = string.format('%s(%s)_hq.mp4', current_file, time)
    local full_path = vim.fn.expand("~/Movies/") .. output_filename

    local cmd = string.format(
        [[ffmpeg -y -f avfoundation -r 60 -i "3:none" -filter:v "crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=7:7:1.0:7:7:0.0" -crf 18 -preset veryslow "%s"]],
        full_path
    )

    print("High quality recording to: " .. full_path)

    local job_id = vim.fn.jobstart(cmd, { detach = true })
    vim.g.recording_job_id = job_id
end

local function stop_record()
    if vim.g.recording_job_id then
        vim.fn.jobstop(vim.g.recording_job_id)
        print("Recording stopped.")
        vim.g.recording_job_id = nil
    else
        print("No active recording!")
    end
end

vim.api.nvim_create_user_command("Screenshot", aesthetic_screenshot, {})
vim.api.nvim_create_user_command("RecordStop", stop_record, {})
vim.api.nvim_create_user_command("Record", aesthetic_record, {})
vim.api.nvim_create_user_command("RecordHQ", aesthetic_record_hq, {})


local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"


local recording_actions = {
    "Screenshot",
    "RecordStop",
    "Record",
    "RecordHQ",
}

local function record_picker()
    pickers.new({}, {
        prompt_title = "Select Recording Action",
        finder = finders.new_table {
            results = recording_actions,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local cmd = selection[1]
                if cmd then
                    vim.cmd(cmd)
                else
                    vim.notify("No selection made!", vim.log.levels.WARN)
                end
            end)
            return true
        end,
    }):find()
end

vim.api.nvim_create_user_command("RecordPicker", record_picker, {})
