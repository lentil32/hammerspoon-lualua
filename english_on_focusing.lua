local input_source_controller = require("input_source_controller")

local M = {}

-- Define a list of applications for which you want to include to the input source change
local apps_to_include = {
    "Emacs",
    "Alacritty",
}

-- Function to check and set the input source
local function check_and_set_input_source()
  local currentApp = hs.application.frontmostApplication()
  if currentApp and hs.fnutils.contains(apps_to_include, currentApp:name()) then
    input_source_controller.set_input_source_to_english()
  end
end

-- Create an application watcher
local app_watcher = hs.application.watcher.new(function(app_name, event_type, app)
  if event_type == hs.application.watcher.activated then
    -- Delay the function call to ensure the focus has fully switched
    hs.timer.doAfter(0.1, check_and_set_input_source)
  end
end)

-- Function to initialize the application watcher
local function init_app_watcher()
  app_watcher:start()
  -- Initially check and set the input source for the currently focused application
  check_and_set_input_source()
end

-- Export the module table
M.init_app_watcher = init_app_watcher

return M
