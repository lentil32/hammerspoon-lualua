-- i3-like window management for Hammerspoon
-- Main entry point

-- Load all modules
local config = require("wm.config")
local modes = require("wm.modes")
local tiling = require("wm.tiling")
local focus = require("wm.focus")
local workspaces = require("wm.workspaces")
local hotkeys = require("wm.hotkeys")
local rules = require("wm.rules")

-- Initialize modules
hotkeys.register()
rules.startWatchers()

-- Start in main mode
modes.changeMode("main")

-- Show welcome message
hs.alert.show("i3-like window management loaded")

-- Return module for API access
return {
    config = config,
    modes = modes,
    tiling = tiling,
    focus = focus,
    workspaces = workspaces,
    hotkeys = hotkeys,
    rules = rules
}
