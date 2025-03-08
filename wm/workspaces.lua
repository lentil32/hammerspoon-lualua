-- Workspace/space management functions
local workspaces = {}

-- Load dependencies
local spaces = hs.spaces
local screen = hs.screen
local window = hs.window
local alert = hs.alert

-- Switch to workspace (via macOS spaces)
function workspaces.switchToWorkspace(num)
    -- Try to get spaces from hs.spaces, fall back to keyboard shortcut
    local allSpaces = spaces.allSpaces()
    local currentScreen = screen.mainScreen():getUUID()

    if allSpaces and allSpaces[currentScreen] and #allSpaces[currentScreen] >= num then
        spaces.gotoSpace(allSpaces[currentScreen][num])
    else
        -- Fallback to keyboard shortcut for space switching
        hs.eventtap.keyStroke({"ctrl"}, tostring(num))
    end

    alert.show("Workspace " .. num)
end

-- Move window to workspace
function workspaces.moveWindowToWorkspace(num)
    local win = window.focusedWindow()
    if not win then return end

    local allSpaces = spaces.allSpaces()
    local currentScreen = screen.mainScreen():getUUID()

    if allSpaces and allSpaces[currentScreen] and #allSpaces[currentScreen] >= num then
        spaces.moveWindowToSpace(win:id(), allSpaces[currentScreen][num])
        spaces.gotoSpace(allSpaces[currentScreen][num])
    else
        -- Fallback alert for manual movement
        alert.show("To move window to Workspace " .. num .. ":\n" ..
                  "1. Control+Up for Mission Control\n" ..
                  "2. Drag window to desired Space", 3)
        hs.timer.doAfter(0.3, function()
            hs.eventtap.keyStroke({"ctrl"}, "up")
        end)
    end
end

return workspaces
