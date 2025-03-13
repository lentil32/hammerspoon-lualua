local input_source_controller = require("input_source_controller")

local M = {}

local esc_bind
local esc_processing = false

local function convert_to_eng_with_esc()
    esc_bind:disable()
    input_source_controller.set_input_source_to_english()
    hs.eventtap.keyStroke({}, 'escape')

    esc_processing = false
    esc_bind:enable()
end

esc_bind = hs.hotkey.new({}, 'escape', function()
    if not esc_processing then
        esc_processing = true
        convert_to_eng_with_esc()
    end
end):enable()

M.esc_bind = esc_bind
return M
