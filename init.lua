local english_input_config = require("config.english_input")
local english_input_runtime = require("english_input.runtime")

local runtime = english_input_runtime.create(english_input_config)

runtime.start()
hs.alert.show("Hammerspoon script loaded.")
