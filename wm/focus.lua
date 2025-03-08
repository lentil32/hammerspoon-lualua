-- Window focus and movement functions
local focus = {}

-- Load dependencies
local config = require("wm.config")
local window = hs.window

-- Focus window in direction
function focus.focusWindow(direction)
    local win = window.focusedWindow()
    if not win then return end
    if direction == "left" then
        win:focusWindowWest(nil, true)
    elseif direction == "right" then
        win:focusWindowEast(nil, true)
    elseif direction == "up" then
        win:focusWindowNorth(nil, true)
    elseif direction == "down" then
        win:focusWindowSouth(nil, true)
    end
end

-- Move window in direction by swapping with adjacent window
function focus.moveWindow(direction)
    local win = window.focusedWindow()
    if not win then return end
    -- Try to find a window in the specified direction
    local adjacentWin = nil
    if direction == "left" then
        adjacentWin = win:windowsToWest(nil, true)[1]
    elseif direction == "right" then
        adjacentWin = win:windowsToEast(nil, true)[1]
    elseif direction == "up" then
        adjacentWin = win:windowsToNorth(nil, true)[1]
    elseif direction == "down" then
        adjacentWin = win:windowsToSouth(nil, true)[1]
    end
    if adjacentWin then
        -- Swap frames with the adjacent window
        local winFrame = win:frame()
        local adjFrame = adjacentWin:frame()
        win:setFrame(adjFrame)
        adjacentWin:setFrame(winFrame)
    else
        -- Fallback to moving by steps if no adjacent window
        local frame = win:frame()
        local screenFrame = win:screen():frame()
        local step = 50
        if direction == "left" then
            frame.x = math.max(frame.x - step, screenFrame.x)
        elseif direction == "right" then
            frame.x = math.min(frame.x + step, screenFrame.x + screenFrame.w - frame.w)
        elseif direction == "up" then
            frame.y = math.max(frame.y - step, screenFrame.y)
        elseif direction == "down" then
            frame.y = math.min(frame.y + step, screenFrame.y + screenFrame.h - frame.h)
        end
        win:setFrame(frame)
    end
end

return focus
