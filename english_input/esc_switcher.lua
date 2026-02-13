local M = {}
local ESCAPE_KEY = "escape"

local function frontmost_app_name(application_api)
  local app = application_api.frontmostApplication()
  if app == nil then
    return nil
  end
  return app:name()
end

local function create(options)
  local hotkey_api = options.hotkey
  local eventtap_api = options.eventtap
  local application_api = options.application
  local is_target_app = options.is_target_app
  local set_input_source_to_english = options.set_input_source_to_english

  local is_processing = false
  local esc_bind

  local function maybe_switch_to_english_for_frontmost_app()
    local app_name = frontmost_app_name(application_api)
    if app_name ~= nil and is_target_app(app_name) then
      set_input_source_to_english()
    end
  end

  local function on_escape_pressed()
    if is_processing then
      return
    end

    is_processing = true
    esc_bind:disable()
    maybe_switch_to_english_for_frontmost_app()
    eventtap_api.keyStroke({}, ESCAPE_KEY)
    is_processing = false
    esc_bind:enable()
  end

  esc_bind = hotkey_api.new({}, ESCAPE_KEY, on_escape_pressed)

  return {
    start = function()
      esc_bind:enable()
    end,
    stop = function()
      esc_bind:disable()
    end,
  }
end

M.create = create
return M
