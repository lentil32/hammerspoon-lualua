-- Application window rules
local rules = {}

-- Load dependencies
local config = require("wm.config")
local workspaces = require("wm.workspaces")
local tiling = require("wm.tiling")

-- Application window rules
rules.windowRules = {
    ["org.gnu.Emacs"] = {workspace = 2, floating = true},
    ["company.thebrowser.Browser"] = {workspace = 3},
    ["com.linear"] = {workspace = 4},
    ["com.tinyspeck.slackmacgap"] = {workspace = 4},
    ["com.spotify.client"] = {workspace = 10},
    ["com.github.th-ch.youtube-music"] = {workspace = 10},
    ["com.vanejung.elpy"] = {workspace = 10},
    ["com.hnc.Discord"] = {workspace = 9}
}

-- Start all watchers
function rules.startWatchers()
    -- Track window creation and destruction
    local windowWatcher = hs.window.filter.new(true)
    windowWatcher:subscribe(hs.window.filter.windowCreated, function(win)
        local id = win:id()
        if not config.windowState[id] then
            config.windowState[id] = { floating = false }
        end
        -- Reapply tiling layout after a short delay
        hs.timer.doAfter(0.1, tiling.applyTilingLayout)
    end)

    windowWatcher:subscribe(hs.window.filter.windowDestroyed, function(win)
        local id = win:id()
        config.windowState[id] = nil
        -- Reapply tiling layout
        tiling.applyTilingLayout()
    end)

    -- Application watcher to apply rules when apps are launched
    local appWatcher = hs.application.watcher.new(function(appName, eventType, appObj)
        if eventType == hs.application.watcher.launched then
            -- Give the app a moment to create its window
            hs.timer.doAfter(0.5, function()
                if appObj and appObj:isRunning() then
                    local win = appObj:mainWindow()
                    if not win then return end
                    local bundleID = appObj:bundleID()
                    local rule = rules.windowRules[bundleID]
                    if rule then
                        if rule.workspace then
                            workspaces.switchToWorkspace(rule.workspace)
                        end
                        if rule.floating then
                            config.windowState[win:id()] = { floating = true }
                            -- Apply centered floating layout
                            local screenFrame = win:screen():frame()
                            win:setFrame({
                                x = screenFrame.x + screenFrame.w * 0.2,
                                y = screenFrame.y + screenFrame.h * 0.2,
                                w = screenFrame.w * 0.6,
                                h = screenFrame.h * 0.6
                            })
                        end
                    end
                end
            end)
        end
    end)

    appWatcher:start()
end

return rules
