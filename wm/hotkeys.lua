-- Hotkey registration functions
local hotkeys = {}

-- Load dependencies
local config = require("wm.config")
local modes = require("wm.modes")
local tiling = require("wm.tiling")
local focus = require("wm.focus")
local workspaces = require("wm.workspaces")
local hotkey = hs.hotkey

-- Register all hotkeys
function hotkeys.register()
    hotkeys.registerMainModeHotkeys()
    hotkeys.registerResizeModeHotkeys()
    hotkeys.registerProgramsModeHotkeys()
end

-- Main mode hotkeys
function hotkeys.registerMainModeHotkeys()
    -- Focus windows
    modes.modals.main.focusLeft = hotkey.bind(config.hyper, "h", function() focus.focusWindow("left") end)
    modes.modals.main.focusDown = hotkey.bind(config.hyper, "j", function() focus.focusWindow("down") end)
    modes.modals.main.focusUp = hotkey.bind(config.hyper, "k", function() focus.focusWindow("up") end)
    modes.modals.main.focusRight = hotkey.bind(config.hyper, "l", function() focus.focusWindow("right") end)

    -- Move windows
    modes.modals.main.moveLeft = hotkey.bind(config.hyperShift, "h", function() focus.moveWindow("left") end)
    modes.modals.main.moveDown = hotkey.bind(config.hyperShift, "j", function() focus.moveWindow("down") end)
    modes.modals.main.moveUp = hotkey.bind(config.hyperShift, "k", function() focus.moveWindow("up") end)
    modes.modals.main.moveRight = hotkey.bind(config.hyperShift, "l", function() focus.moveWindow("right") end)

    -- Split windows
    modes.modals.main.splitHorizontal = hotkey.bind(config.hyperShift, "v", function() tiling.splitWindow("horizontal") end)
    modes.modals.main.splitVertical = hotkey.bind(config.hyper, "v", function() tiling.splitWindow("vertical") end)

    -- Fullscreen and floating
    modes.modals.main.fullscreen = hotkey.bind(config.hyper, "f", tiling.toggleFullscreen)
    modes.modals.main.floatingToggle = hotkey.bind(config.hyperShift, "space", tiling.toggleFloating)

    -- Layout types
    modes.modals.main.layoutStacking = hotkey.bind(config.hyper, "s", function() tiling.applyLayout("v_accordion") end)
    modes.modals.main.layoutTabbed = hotkey.bind(config.hyper, "w", function() tiling.applyLayout("h_accordion") end)
    modes.modals.main.layoutTiles = hotkey.bind(config.hyper, "e", function() tiling.applyLayout("tiles") end)

    -- Launch terminal
    modes.modals.main.terminal = hotkey.bind(config.hyper, "return", function() hs.execute("open -na Alacritty") end)

    -- Workspaces 1-10
    modes.modals.main.workspace = {}
    modes.modals.main.moveToWorkspace = {}
    for i = 0, 9 do
        local wsNum = i == 0 and 10 or i
        modes.modals.main.workspace[i] = hotkey.bind(config.hyper, tostring(i), function()
            workspaces.switchToWorkspace(wsNum)
        end)
        modes.modals.main.moveToWorkspace[i] = hotkey.bind(config.hyperShift, tostring(i), function()
            workspaces.moveWindowToWorkspace(wsNum)
        end)
    end

    -- Mode switching
    modes.modals.main.toResizeMode = hotkey.bind(config.hyper, "r", function() modes.changeMode("resize") end)
    modes.modals.main.toProgramsMode = hotkey.bind(config.hyperShift, "p", function() modes.changeMode("programs") end)

    -- Reload config
    modes.modals.main.reloadConfig = hotkey.bind(config.hyperShift, "c", hs.reload)
end

-- Resize mode hotkeys
function hotkeys.registerResizeModeHotkeys()
    modes.modals.resize.narrower = hotkey.new({}, "h", function() tiling.resizeWindow("width", -50) end)
    modes.modals.resize.taller = hotkey.new({}, "j", function() tiling.resizeWindow("height", 50) end)
    modes.modals.resize.shorter = hotkey.new({}, "k", function() tiling.resizeWindow("height", -50) end)
    modes.modals.resize.wider = hotkey.new({}, "l", function() tiling.resizeWindow("width", 50) end)
    modes.modals.resize.enterKey = hotkey.new({}, "return", function() modes.changeMode("main") end)
    modes.modals.resize.escapeKey = hotkey.new({}, "escape", function() modes.changeMode("main") end)

    -- Disable initially
    for _, hk in pairs(modes.modals.resize) do
        hk:disable()
    end
end

-- Programs mode hotkeys
function hotkeys.registerProgramsModeHotkeys()
    modes.modals.programs.anki = hotkey.new({}, "a", function()
        hs.execute("open -a Anki")
        modes.changeMode("main")
    end)
    modes.modals.programs.chrome = hotkey.new({}, "c", function()
        hs.execute("open -na 'Google Chrome'")
        modes.changeMode("main")
    end)
    modes.modals.programs.emacs = hotkey.new({}, "e", function()
        hs.execute("emacsclient -ca 'open -a Emacs'")
        modes.changeMode("main")
    end)
    modes.modals.programs.firefox = hotkey.new({}, "f", function()
        hs.execute("open -na 'Firefox'")
        modes.changeMode("main")
    end)
    modes.modals.programs.firefoxDev = hotkey.new({"shift"}, "f", function()
        hs.execute("open -na 'Firefox Developer Edition'")
        modes.changeMode("main")
    end)
    modes.modals.programs.enpass = hotkey.new({}, "p", function()
        hs.execute("open -a Enpass")
        modes.changeMode("main")
    end)
    modes.modals.programs.raycast = hotkey.new({}, "r", function()
        hs.execute("open -a Raycast")
        modes.changeMode("main")
    end)
    modes.modals.programs.enterKey = hotkey.new({}, "return", function() modes.changeMode("main") end)
    modes.modals.programs.escapeKey = hotkey.new({}, "escape", function() modes.changeMode("main") end)

    -- Disable initially
    for _, hk in pairs(modes.modals.programs) do
        hk:disable()
    end
end

return hotkeys
