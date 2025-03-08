-- Configuration settings
local config = {}

-- Modifier combinations
config.hyper = {"ctrl", "alt", "cmd"}
config.hyperShift = {"ctrl", "alt", "cmd", "shift"}

-- Disable window animations
hs.window.animationDuration = 0

-- Window state tracking
config.windowState = {}

-- Current mode
config.defaultMode = "main"

return config
