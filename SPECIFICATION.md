# Full Specification Document for i3-like Hammerspoon Window Manager

## Introduction
This document outlines a detailed specification for an **i3-like window manager** built using **Hammerspoon**, a powerful automation tool for macOS. The system provides:

- **Dynamic tiling window management**: Automatically adjusts window layouts based on their number and size.
- **Intelligent workspace handling**: Manages multiple workspaces across screens.
- **Modal hotkey controls**: Emulates the efficiency of the i3 window manager with flexible, mode-based keybindings.

It serves as both an **implementation guide** and a **framework for future enhancements**, leveraging Hammerspoon's flexibility to create an i3-inspired experience on macOS.

---

## Architecture Overview
The window manager is organized into modular Lua scripts located in the `wm/` directory. Each module handles a specific function:

- **`init.lua`**  
  - **Purpose**: Initializes the system.  
  - **Key Tasks**: Loads and configures all modules, sets the default mode, starts watchers for applications and windows, and provides an API entry point.

- **`config.lua`**  
  - **Purpose**: Stores global settings.  
  - **Key Features**: Defines modifier keys, tracks window states, sets tiling options, and adjusts gap sizes. Centralizes customization options.

- **`rules.lua`**  
  - **Purpose**: Manages application-specific rules.  
  - **Key Tasks**:  
    - Assigns windows to workspaces based on **bundle IDs**.  
    - Toggles **floating mode** for specific apps.  
    - Centers and resizes windows on launch.

- **`modes.lua`**  
  - **Purpose**: Controls operational modes (**main**, **resize**, **programs**).  
  - **Key Tasks**: Switches modes by enabling/disabling hotkeys and shows visual alerts (e.g., via `hs.alert.show`).

- **`focus.lua`**  
  - **Purpose**: Handles window focus and movement.  
  - **Key Features**: Supports directional focus switching, window swapping, and prioritizes the focused window as the **master** position.

- **`hotkeys.lua`**  
  - **Purpose**: Manages global hotkey bindings.  
  - **Key Features**: Abstracts Hammerspoon’s hotkey API for mode-specific actions and supports hotkey reloading.

- **`workspaces.lua`**  
  - **Purpose**: Interfaces with Hammerspoon’s **spaces API** for workspace management.  
  - **Key Features**: Maps workspace numbers to screens/spaces and moves windows with user feedback.

- **`tiling.lua`**  
  - **Purpose**: Implements tiling algorithms.  
  - **Key Features**:  
    - Adapts layouts for single, dual, or multiple windows.  
    - Calculates positions with gaps.  
    - Toggles between tiled and floating states, preserving original frames.

---

## Functional Specifications

### Tiling Layout
- **Dynamic Tiling**  
  - **Behavior**: Updates layouts automatically when windows are added, removed, or resized.  
  - **Process**:  
    - Groups windows by screen.  
    - Excludes floating windows.  
    - Adjusts for outer and inner gaps.

- **Layout Variants**  
  - **Single Window**: Fills the entire usable screen area.  
  - **Two Windows**: Splits the screen evenly; orientation (horizontal/vertical) depends on screen aspect ratio.  
  - **Multiple Windows**:  
    - Focused window becomes the **master** (larger area).  
    - Other windows stack evenly in the remaining space.

- **Floating Mode**  
  - **Behavior**: Toggles windows to a floating state, centering them with a set size.  
  - **Feature**: Stores original frames for easy restoration to tiling.

### Modal Hotkey Management
- **Mode Definitions**  
  - **Main Mode**: Default mode for window management, workspace navigation, and layout tweaks.  
  - **Resize Mode**: Allows precise window resizing.  
  - **Programs Mode**: Launches or focuses common applications.

- **Mode Switching**  
  - **Process**:  
    - Disables previous mode’s hotkeys.  
    - Enables new mode’s hotkeys.  
    - Shows visual alerts (e.g., `hs.alert.show`).  
  - **Feature**: Supports reloading bindings dynamically.

### Workspace Management
- **Workspace Switching**  
  - **Behavior**: Uses numeric hotkeys to switch workspaces via Hammerspoon’s spaces API.  
  - **Details**:  
    - Adapts to multi-screen setups.  
    - Alerts users if a workspace is unavailable.

- **Window Assignment**  
  - **Behavior**: Moves the focused window to a specified workspace, updating its position and active space.

- **Automatic Rules**  
  - **Behavior**: Applies rules to route windows to workspaces or set floating layouts based on application properties.

### Application Rules
- **Rule Matching**  
  - **Method**: Matches rules using application **bundle IDs** during launch or window creation.  
- **Actions**  
  - Routes windows to specific workspaces.  
  - Applies centered, scaled floating layouts for designated apps.

---

## Detailed Module Design
Each module is designed for clarity and reliability:

- **`init.lua`**  
  - Initializes modules in a specific order to resolve dependencies.

- **`config.lua`**  
  - Central hub for adjustable settings.

- **`rules.lua`**  
  - Watches applications/windows and applies rules with a delay for stability.

- **`modes.lua`**  
  - Manages mode state and safe transitions.

- **`hotkeys.lua`**  
  - Organizes hotkeys hierarchically by mode.

- **`workspaces.lua`**  
  - Handles workspace logic with error alerts.

- **`tiling.lua`**  
  - Encapsulates tiling logic and frame preservation.

- **`focus.lua`**  
  - Manages focus and movement with fallbacks.

---

## Performance, Scalability, and Error Handling
- **Performance Optimization**  
  - Throttles layout updates with timers.  
  - Excludes floating windows from unnecessary recalculations.

- **Error Handling**  
  - Uses guard clauses for null references.  
  - Shows alerts for failed actions (e.g., workspace errors).

- **Scalability**  
  - Supports multiple monitors and window counts.  
  - Modular design allows easy feature additions.

---

## References and Inspirations
- **i3 Window Manager**: Core inspiration for tiling and workspaces.  
- **Aerospace Configuration**: Guides hotkey and layout design.  
- **Hammerspoon API**: Enables macOS integration via Lua.

---

## Future Enhancements
- **Dynamic Configuration Reloading**: Update settings without restarting.  
- **Expanded Layouts**: Add grid or cascading options.  
- **Logging/Debugging**: Improve diagnostics.  
- **UI Improvements**: Enhance alerts and indicators.  
- **macOS Integration**: Leverage Mission Control and Spaces.

---

## Conclusion
This specification defines a robust i3-like window manager for macOS using Hammerspoon. It details module roles, functionality, and growth potential, acting as a blueprint for implementation and development.

---

## Appendix: Aerospace Configuration
Below is the reference Aerospace configuration, which informs the Hammerspoon hotkeys and tiling behavior to mirror the i3 experience.

```md
# Reference: https://github.com/i3/i3/blob/next/etc/config

# Commands run after login to macOS user session
after-login-command = []

# Commands run after AeroSpace startup
after-startup-command = []

# Start AeroSpace at login
start-at-login = true

# Normalizations (disabled to match i3 behavior)
enable-normalization-flatten-containers = false
enable-normalization-opposite-orientation-for-nested-containers = false

# Layout settings
accordion-padding = 30
default-root-container-layout = 'tiles'
default-root-container-orientation = 'auto'

# Mouse follows focus when focused monitor changes
on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

# Gaps between windows and monitor edges
[gaps]
inner.horizontal = 0
inner.vertical =   0
outer.left =       0
outer.bottom =     65
outer.top =        0
outer.right =      0

# Workspace to monitor force assignment
[workspace-to-monitor-force-assignment]
2 = 'main'
6 = 'secondary'

# Application-specific rules
[[on-window-detected]]
if.app-id = 'org.gnu.Emacs'
if.workspace = '2'
run = ['layout floating']

[[on-window-detected]]
if.app-id = 'company.thebrowser.Browser'
run = 'move-node-to-workspace 3' # W - Web browser

[[on-window-detected]]
if.app-id = 'com.linear'
run = 'move-node-to-workspace 4'

[[on-window-detected]]
if.app-id = 'com.tinyspeck.slackmacgap'
run = 'move-node-to-workspace 4'

[[on-window-detected]]
if.app-id = 'com.spotify.client'
run = 'move-node-to-workspace 10' # M - Media

[[on-window-detected]]
if.app-id = 'com.github.th-ch.youtube-music'
run = 'move-node-to-workspace 10' # M - Media

[[on-window-detected]]
if.app-id = 'com.vanejung.elpy'
run = 'move-node-to-workspace 10' # M - Media

[[on-window-detected]]
if.app-id = 'com.hnc.Discord'
run = 'move-node-to-workspace 9' # S - Social Network

# Main mode bindings
[mode.main.binding]
ctrl-alt-cmd-enter = 'exec-and-forget open -na Alacritty'

ctrl-alt-cmd-h = 'focus left'
ctrl-alt-cmd-j = 'focus down'
ctrl-alt-cmd-k = 'focus up'
ctrl-alt-cmd-l = 'focus right'

ctrl-alt-cmd-shift-h = 'move left'
ctrl-alt-cmd-shift-j = 'move down'
ctrl-alt-cmd-shift-k = 'move up'
ctrl-alt-cmd-shift-l = 'move right'

ctrl-alt-cmd-shift-v = 'split horizontal'
ctrl-alt-cmd-v = 'split vertical'

ctrl-alt-cmd-f = 'fullscreen'

ctrl-alt-cmd-s = 'layout v_accordion' # 'layout stacking' in i3
ctrl-alt-cmd-w = 'layout h_accordion' # 'layout tabbed' in i3
ctrl-alt-cmd-e = 'layout tiles horizontal vertical' # 'layout toggle split' in i3

ctrl-alt-cmd-shift-space = 'layout floating tiling' # 'floating toggle' in i3

ctrl-alt-cmd-space = 'focus toggle_tiling_floating'

ctrl-alt-cmd-a = 'focus parent'

ctrl-alt-cmd-1 = 'workspace 1'
ctrl-alt-cmd-2 = 'workspace 2'
ctrl-alt-cmd-3 = 'workspace 3'
ctrl-alt-cmd-4 = 'workspace 4'
ctrl-alt-cmd-5 = 'workspace 5'
ctrl-alt-cmd-6 = 'workspace 6'
ctrl-alt-cmd-7 = 'workspace 7'
ctrl-alt-cmd-8 = 'workspace 8'
ctrl-alt-cmd-9 = 'workspace 9'
ctrl-alt-cmd-0 = 'workspace 10'

ctrl-alt-cmd-shift-1 = 'move-node-to-workspace 1'
# ... (continues to ctrl-alt-cmd-shift-0)
ctrl-alt-cmd-shift-0 = 'move-node-to-workspace 10'

ctrl-alt-cmd-shift-c = 'reload-config'

ctrl-alt-cmd-r = 'mode resize'
ctrl-alt-cmd-shift-p = 'mode programs'
```
