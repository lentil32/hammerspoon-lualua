-- Mode management
local modes = {}

-- Load dependencies
local config = require("wm.config")

-- Current mode
modes.current = config.defaultMode

-- Modal hotkey bindings
modes.modals = {
    main = {},
    resize = {},
    programs = {}
}

-- Change between modes
function modes.changeMode(mode)
    -- Disable all hotkeys in current mode
    for _, hotkeys in pairs(modes.modals) do
        for _, hk in pairs(hotkeys) do
            if type(hk) == "table" and hk.disable then
                hk:disable()
            elseif type(hk) == "table" then
                for _, subHk in pairs(hk) do
                    if subHk.disable then subHk:disable() end
                end
            end
        end
    end

    modes.current = mode

    -- Enable hotkeys for new mode
    for _, hk in pairs(modes.modals[mode]) do
        if type(hk) == "table" and hk.enable then
            hk:enable()
        elseif type(hk) == "table" then
            for _, subHk in pairs(hk) do
                if subHk.enable then subHk:enable() end
            end
        end
    end

    hs.alert.show("Mode: " .. mode)
end

return modes
