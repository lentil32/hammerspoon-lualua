local input_source_controller = require("input_source_controller")

-- Define the module table
local M = {}

-- Private module variables
local esc_bind
local esc_processing = false

-- Function to convert input source to English and send ESC key
local function convert_to_eng_with_esc()
  -- Disable the ESC key binding to prevent recursion
  esc_bind:disable()

  input_source_controller.set_input_source_to_english()

  -- Send the ESC key
  hs.eventtap.keyStroke({}, 'escape')

  -- Enable the ESC key binding
  esc_processing = false
  esc_bind:enable()
end

-- Create the ESC key binding with conditional logic
esc_bind = hs.hotkey.new({}, 'escape', function()
  -- Check if the ESC key is not currently being processed
  if not esc_processing then
    esc_processing = true
    convert_to_eng_with_esc()
  end
end):enable()

-- Export the module table
M.esc_bind = esc_bind

return M
