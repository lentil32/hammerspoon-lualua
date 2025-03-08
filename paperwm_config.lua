-- Load required Hammerspoon modules
local spaces = require("hs.spaces")
local wf = hs.window.filter.new(false)

-- Helper function to get a space ID by index
function getSpace(index)
    local all_spaces = spaces.allSpaces()
    for screen_uuid, screen_spaces in pairs(all_spaces) do
        if screen_spaces[index] then
            return screen_spaces[index]
        end
    end
    return nil
end

-- Helper function to get the index of a given space ID
function getSpaceIndex(space)
    local all_spaces = spaces.allSpaces()
    for screen_uuid, screen_spaces in pairs(all_spaces) do
        for idx, s in ipairs(screen_spaces) do
            if s == space then
                return idx
            end
        end
    end
    return nil
end

-- Window filter to handle app-specific rules from Aerospace's on-window-detected
wf:subscribe(hs.window.filter.windowCreated, function(window, appName, event)
    local bundleID = window:application():bundleID()
    if bundleID == "org.gnu.Emacs" then
        local current_space = spaces.windowSpaces(window)[1]
        local space_index = getSpaceIndex(current_space)
        if space_index == 2 then
            PaperWM.floating_windows[window:id()] = true
        end
    elseif bundleID == "company.thebrowser.Browser" then
        local space = getSpace(3)
        if space then
            spaces.moveWindowToSpace(window, space)
        end
    elseif bundleID == "com.linear" then
        local space = getSpace(4)
        if space then
            spaces.moveWindowToSpace(window, space)
        end
    elseif bundleID == "com.tinyspeck.slackmacgap" then
        local space = getSpace(4)
        if space then
            spaces.moveWindowToSpace(window, space)
        end
    elseif bundleID == "com.spotify.client" then
        local space = getSpace(9)
        if space then
            spaces.moveWindowToSpace(window, space)
        end
    elseif bundleID == "com.github.th-ch.youtube-music" then
        local space = getSpace(9)
        if space then
            spaces.moveWindowToSpace(window, space)
        end
    elseif bundleID == "com.vanejung.elpy" then
        local space = getSpace(9)
        if space then
            spaces.moveWindowToSpace(window, space)
        end
    elseif bundleID == "com.hnc.Discord" then
        local space = getSpace(8)
        if space then
            spaces.moveWindowToSpace(window, space)
        end
    end
end)

-- Load PaperWM spoon
PaperWM = hs.loadSpoon("PaperWM")

-- Configure PaperWM settings based on Aerospace gaps
-- number of fingers to detect a horizontal swipe, set to 0 to disable (the default)
PaperWM.swipe_fingers = 3
-- increase this number to make windows move farther when swiping
PaperWM.swipe_gain = 3.0
PaperWM.window_gap = 0          -- Matches inner.horizontal and inner.vertical = 0
PaperWM.screen_margin = 0       -- Matches outer.left, top, right = 0; bottom = 65 not fully supported

-- Bind PaperWM hotkeys, mirroring Aerospace keybindings
PaperWM:bindHotkeys({
    focus_left = {{"ctrl", "alt", "cmd"}, "h"},
    focus_down = {{"ctrl", "alt", "cmd"}, "j"},
    focus_up = {{"ctrl", "alt", "cmd"}, "k"},
    focus_right = {{"ctrl", "alt", "cmd"}, "l"},
    swap_left = {{"ctrl", "alt", "cmd", "shift"}, "h"},    -- 'move left'
    swap_down = {{"ctrl", "alt", "cmd", "shift"}, "j"},    -- 'move down'
    swap_up = {{"ctrl", "alt", "cmd", "shift"}, "k"},      -- 'move up'
    swap_right = {{"ctrl", "alt", "cmd", "shift"}, "l"},   -- 'move right'
    toggle_floating = {{"ctrl", "alt", "cmd", "shift"}, "space"},
    switch_space_1 = {{"ctrl", "alt", "cmd"}, "1"},        -- 'workspace 1'
    switch_space_2 = {{"ctrl", "alt", "cmd"}, "2"},
    switch_space_3 = {{"ctrl", "alt", "cmd"}, "3"},
    switch_space_4 = {{"ctrl", "alt", "cmd"}, "4"},
    switch_space_5 = {{"ctrl", "alt", "cmd"}, "5"},
    switch_space_6 = {{"ctrl", "alt", "cmd"}, "6"},
    switch_space_7 = {{"ctrl", "alt", "cmd"}, "7"},
    switch_space_8 = {{"ctrl", "alt", "cmd"}, "8"},
    switch_space_9 = {{"ctrl", "alt", "cmd"}, "9"},
    move_window_1 = {{"ctrl", "alt", "cmd", "shift"}, "1"}, -- 'move-node-to-workspace 1'
    move_window_2 = {{"ctrl", "alt", "cmd", "shift"}, "2"},
    move_window_3 = {{"ctrl", "alt", "cmd", "shift"}, "3"},
    move_window_4 = {{"ctrl", "alt", "cmd", "shift"}, "4"},
    move_window_5 = {{"ctrl", "alt", "cmd", "shift"}, "5"},
    move_window_6 = {{"ctrl", "alt", "cmd", "shift"}, "6"},
    move_window_7 = {{"ctrl", "alt", "cmd", "shift"}, "7"},
    move_window_8 = {{"ctrl", "alt", "cmd", "shift"}, "8"},
    move_window_9 = {{"ctrl", "alt", "cmd", "shift"}, "9"},
})

-- Additional hotkeys not directly supported by PaperWM
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "return", function()
    hs.execute("open -na Alacritty")  -- 'exec-and-forget open -na Alacritty'
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "f", function()
    local win = hs.window.focusedWindow()
    if win then
        win:setFullScreen(not win:isFullScreen())  -- 'fullscreen'
    end
end)

hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "c", function()
    hs.reload()  -- 'reload-config'
end)

-- Resize mode
local resize_mode = hs.hotkey.modal.new({"ctrl", "alt", "cmd"}, "r")

function resize_mode:entered()
    hs.alert("Entered resize mode")
end

function resize_mode:exited()
    hs.alert("Exited resize mode")
end

resize_mode:bind('', 'h', function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        f.w = f.w - 50
        win:setFrame(f)
    end
end)

resize_mode:bind('', 'l', function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        f.w = f.w + 50
        win:setFrame(f)
    end
end)

resize_mode:bind('', 'j', function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        f.h = f.h + 50
        win:setFrame(f)
    end
end)

resize_mode:bind('', 'k', function()
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        f.h = f.h - 50
        win:setFrame(f)
    end
end)

resize_mode:bind('', 'escape', function()
    resize_mode:exit()
end)

resize_mode:bind('', 'return', function()
    resize_mode:exit()
end)

-- Programs mode
local programs_mode = hs.hotkey.modal.new({"ctrl", "alt", "cmd", "shift"}, "p")

function programs_mode:entered()
    hs.alert("Entered programs mode")
end

function programs_mode:exited()
    hs.alert("Exited programs mode")
end

programs_mode:bind('', 'a', function()
    hs.execute("open -a Anki")
    programs_mode:exit()
end)

programs_mode:bind('', 'c', function()
    hs.execute("open -na 'Google Chrome'")
    programs_mode:exit()
end)

programs_mode:bind('', 'e', function()
    hs.execute("/etc/profiles/per-user/starush/bin/emacsclient -ca 'open -a Emacs' &> /dev/null & disown")
    programs_mode:exit()
end)

programs_mode:bind('', 'f', function()
    hs.execute("open -na 'Firefox'")
    programs_mode:exit()
end)

programs_mode:bind('shift', 'f', function()
    hs.execute("open -na 'Firefox Developer Edition'")
    programs_mode:exit()
end)

programs_mode:bind('', 'p', function()
    hs.execute("open -a Enpass")
    programs_mode:exit()
end)

programs_mode:bind('', 'r', function()
    hs.execute("open -a Raycast")
    programs_mode:exit()
end)

programs_mode:bind('', 'escape', function()
    programs_mode:exit()
end)

programs_mode:bind('', 'return', function()
    programs_mode:exit()
end)

-- Start PaperWM
PaperWM:start()
