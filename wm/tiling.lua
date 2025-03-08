-- Window tiling and layout functions
local tiling = {}

-- Load dependencies
local config = require("wm.config")
local window = hs.window
local screen = hs.screen

-- Apply i3-like tiling layout
function tiling.applyTilingLayout()
    local allWindows = window.visibleWindows()
    -- Filter out floating windows
    local tiledWindows = {}
    for _, win in ipairs(allWindows) do
        local id = win:id()
        if not (config.windowState[id] and config.windowState[id].floating) then
            table.insert(tiledWindows, win)
        end
    end
    if #tiledWindows == 0 then return end

    local screenFrame = screen.mainScreen():frame()

    -- Sort windows to maintain consistent order for tiling
    table.sort(tiledWindows, function(a, b) return a:id() < b:id() end)

    if #tiledWindows == 1 then
        -- Single window gets full screen
        tiledWindows[1]:setFrame(screenFrame)
    elseif #tiledWindows == 2 then
        -- Two windows get split horizontally (side by side)
        tiledWindows[1]:setFrame({
            x = screenFrame.x,
            y = screenFrame.y,
            w = screenFrame.w / 2,
            h = screenFrame.h
        })
        tiledWindows[2]:setFrame({
            x = screenFrame.x + screenFrame.w / 2,
            y = screenFrame.y,
            w = screenFrame.w / 2,
            h = screenFrame.h
        })
    else
        -- First window gets left half
        tiledWindows[1]:setFrame({
            x = screenFrame.x,
            y = screenFrame.y,
            w = screenFrame.w / 2,
            h = screenFrame.h
        })

        -- Second window gets top-right quarter
        if #tiledWindows >= 2 then
            tiledWindows[2]:setFrame({
                x = screenFrame.x + screenFrame.w / 2,
                y = screenFrame.y,
                w = screenFrame.w / 2,
                h = screenFrame.h / 2
            })
        end

        -- Third window gets bottom-right quarter
        if #tiledWindows >= 3 then
            tiledWindows[3]:setFrame({
                x = screenFrame.x + screenFrame.w / 2,
                y = screenFrame.y + screenFrame.h / 2,
                w = screenFrame.w / 2,
                h = screenFrame.h / 2
            })
        end

        -- For additional windows (4+), use binary partitioning
        if #tiledWindows >= 4 then
            -- Binary space partitioning helper function
            local function splitArea(area, isHorizontal, windows, startIdx)
                local count = #windows - startIdx + 1
                if count <= 0 then return end

                if count == 1 then
                    windows[startIdx]:setFrame(area)
                    return
                end

                -- Split in half
                local firstHalf = {
                    x = area.x,
                    y = area.y,
                    w = isHorizontal and area.w / 2 or area.w,
                    h = isHorizontal and area.h or area.h / 2
                }

                local secondHalf = {
                    x = isHorizontal and area.x + area.w / 2 or area.x,
                    y = isHorizontal and area.y or area.y + area.h / 2,
                    w = isHorizontal and area.w / 2 or area.w,
                    h = isHorizontal and area.h or area.h / 2
                }

                local midPoint = math.floor(count / 2) + startIdx - 1

                -- Apply recursively to each half
                splitArea(firstHalf, not isHorizontal, windows, startIdx)
                splitArea(secondHalf, not isHorizontal, windows, midPoint + 1)
            end

            -- Create area for remaining windows (4+)
            local rightHalf = {
                x = screenFrame.x + screenFrame.w / 2,
                y = screenFrame.y,
                w = screenFrame.w / 2,
                h = screenFrame.h
            }

            -- Split right half for windows 4+
            splitArea(rightHalf, false, tiledWindows, 4)
        end
    end
end

-- Toggle floating
function tiling.toggleFloating()
    local win = window.focusedWindow()
    if not win then return end
    local id = win:id()
    if not config.windowState[id] then
        config.windowState[id] = { floating = false, originalFrame = win:frame() }
    end
    if config.windowState[id].floating then
        -- Switch from floating to tiled
        config.windowState[id].floating = false
        tiling.applyTilingLayout()
    else
        -- Switch from tiled to floating
        config.windowState[id].floating = true
        config.windowState[id].originalFrame = win:frame()
        -- Apply centered floating layout
        local screenFrame = win:screen():frame()
        win:setFrame({
            x = screenFrame.x + (screenFrame.w - screenFrame.w * 0.6) / 2,
            y = screenFrame.y + (screenFrame.h - screenFrame.h * 0.6) / 2,
            w = screenFrame.w * 0.6,
            h = screenFrame.h * 0.6
        })
    end
end

-- Split window
function tiling.splitWindow(orientation)
    local win = window.focusedWindow()
    if not win then return end
    local frame = win:frame()
    if orientation == "horizontal" then
        -- Split horizontally (one above, one below)
        win:setFrame({
            x = frame.x,
            y = frame.y,
            w = frame.w,
            h = frame.h / 2
        })
    else
        -- Split vertically (one left, one right)
        win:setFrame({
            x = frame.x,
            y = frame.y,
            w = frame.w / 2,
            h = frame.h
        })
    end
    -- Launch a new terminal
    hs.execute("open -na Alacritty")
    hs.timer.doAfter(0.5, function()
        local newWin = window.focusedWindow()
        if newWin and newWin:id() ~= win:id() then
            if orientation == "horizontal" then
                newWin:setFrame({
                    x = frame.x,
                    y = frame.y + frame.h / 2,
                    w = frame.w,
                    h = frame.h / 2
                })
            else
                newWin:setFrame({
                    x = frame.x + frame.w / 2,
                    y = frame.y,
                    w = frame.w / 2,
                    h = frame.h
                })
            end
            config.windowState[newWin:id()] = { floating = false }
        end
    end)
    config.windowState[win:id()] = { floating = false }
end

-- Apply specific layout
function tiling.applyLayout(layoutType)
    if layoutType == "tiles" then
        tiling.applyTilingLayout()
    elseif layoutType == "v_accordion" or layoutType == "h_accordion" then
        -- Stack windows with focused on top
        local win = window.focusedWindow()
        if win then
            win:maximize()
        end
    end
end

-- Toggle fullscreen
function tiling.toggleFullscreen()
    local win = window.focusedWindow()
    if not win then return end
    win:toggleFullScreen()
end

-- Resize window
function tiling.resizeWindow(direction, amount)
    local win = window.focusedWindow()
    if not win then return end
    local frame = win:frame()
    if direction == "width" then
        frame.w = math.max(50, frame.w + amount)
    elseif direction == "height" then
        frame.h = math.max(50, frame.h + amount)
    end
    win:setFrame(frame)
end

return tiling
