-- Applications that should switch to English input when focused
local apps_to_include = {
    "Emacs",
    "Alacritty",
}

-- Make the whitelist available globally
_G.english_apps_whitelist = apps_to_include

local english_on_esc = require("english_on_esc")
local english_on_focusing = require("english_on_focusing")

dofile("paperwm_config.lua")

-- Enable English input on the Esc key
local esc_bind = english_on_esc.esc_bind
esc_bind:enable()

-- Initialize app watcher for focusing events
english_on_focusing.init_app_watcher()

hs.alert.show("Hammerspoon script loaded.")
