local record_path = vim.fn.expand("~/Movies/")

-- currently broken, have to read ffmpeg docs
local function aesthetic_record()
    local current_file = vim.fn.expand("%:t")
    local time = os.date("%H-%M")
    local output_filename = string.format('%s(%s).mp4', current_file, time)
    local path = record_path .. output_filename
    local cmd = string.format(
        [[ffmpeg -y -f avfoundation -r 30 -i "3:none" -filter:v "crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=5:5:1.0:5:5:0.0" -preset ultrafast "%s"]],
        path
    )

    print("Recording to: " .. record_path .. output_filename)
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
    -- local cmd = string.format("open  " .. record_path)
    -- vim.fn.jobstart(cmd)
end

vim.api.nvim_create_user_command("RecordStop", stop_record, {})
vim.api.nvim_create_user_command("Record", aesthetic_record, {})
