local M = {}

local function set_input_source_to_english()
    local input_english = "com.apple.keylayout.UnicodeHexInput"
    local input_source = hs.keycodes.currentSourceID()
    if input_source ~= input_english then
        hs.keycodes.currentSourceID(input_english)
    end
end

M.set_input_source_to_english = set_input_source_to_english
return M
