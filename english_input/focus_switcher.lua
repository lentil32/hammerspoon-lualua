local M = {}

local function frontmost_app_name(application_api)
  local app = application_api.frontmostApplication()
  if app == nil then
    return nil
  end
  return app:name()
end

local function create(options)
  local application_api = options.application
  local application_watcher_api = options.application_watcher
  local timer_api = options.timer
  local is_target_app = options.is_target_app
  local set_input_source_to_english = options.set_input_source_to_english
  local focus_delay_seconds = options.focus_delay_seconds
  if focus_delay_seconds == nil then
    focus_delay_seconds = 0.1
  end
  local activated_event = application_watcher_api.activated

  local function maybe_switch_to_english(app_name)
    if app_name == nil then
      return
    end

    local target_app = is_target_app(app_name)
    if target_app then
      set_input_source_to_english()
    end
  end

  local function on_focus_change()
    maybe_switch_to_english(frontmost_app_name(application_api))
  end

  local app_watcher = application_watcher_api.new(function(_, event_type, _)
    if event_type ~= activated_event then
      return
    end
    timer_api.doAfter(focus_delay_seconds, on_focus_change)
  end)

  return {
    start = function()
      app_watcher:start()
      on_focus_change()
    end,
    stop = function()
      app_watcher:stop()
    end,
  }
end

M.create = create
return M
