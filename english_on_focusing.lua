local input_source_controller = require("input_source_controller")
local M = {}

-- Applications that should switch to English input when focused
local apps_to_include = {
    "Emacs",
    "Alacritty",
}

-- Check if current app is in the monitored list and set input source accordingly
local function check_and_set_input_source()
    local currentApp = hs.application.frontmostApplication()
    if currentApp and hs.fnutils.contains(apps_to_include, currentApp:name()) then
        input_source_controller.set_input_source_to_english()
    end
end

-- Application watcher that detects when apps get focus
local app_watcher = hs.application.watcher.new(function(app_name, event_type, app)
    if event_type == hs.application.watcher.activated then
        -- Small delay to ensure focus has fully switched
        hs.timer.doAfter(0.1, check_and_set_input_source)
    end
end)

-- Initialize the application watcher
local function init_app_watcher()
    app_watcher:start()
    -- Check the currently focused application immediately
    check_and_set_input_source()
end

M.init_app_watcher = init_app_watcher
return M
