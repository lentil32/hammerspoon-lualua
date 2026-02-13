local app_policy = require("english_input.app_policy")
local contracts = require("lib.contracts")
local esc_switcher = require("english_input.esc_switcher")
local focus_switcher = require("english_input.focus_switcher")
local source_controller = require("english_input.source_controller")

local M = {}

local function validate_string_list(values, label)
  contracts.expect_table(values, label)
  for index, value in ipairs(values) do
    contracts.expect_string(value, string.format("%s[%d]", label, index))
  end
end

local function validate_config(config)
  contracts.expect_table(config, "runtime.create options.config")
  contracts.expect_string(config.english_layout_name, "runtime.create options.config.english_layout_name")
  contracts.expect_optional_string(config.english_source_id, "runtime.create options.config.english_source_id")
  validate_string_list(config.target_apps, "runtime.create options.config.target_apps")
  contracts.expect_optional_number(config.focus_delay_seconds, "runtime.create options.config.focus_delay_seconds")
end

local function create(config)
  validate_config(config)

  local policy = app_policy.create({
    target_apps = config.target_apps,
  })

  local input_source = source_controller.create({
    keycodes = hs.keycodes,
    english_layout_name = config.english_layout_name,
    english_source_id = config.english_source_id,
  })

  local esc = esc_switcher.create({
    hotkey = hs.hotkey,
    eventtap = hs.eventtap,
    application = hs.application,
    is_target_app = policy.is_target_app,
    set_input_source_to_english = input_source.set_input_source_to_english,
  })

  local focus = focus_switcher.create({
    application = hs.application,
    application_watcher = hs.application.watcher,
    timer = hs.timer,
    is_target_app = policy.is_target_app,
    set_input_source_to_english = input_source.set_input_source_to_english,
    focus_delay_seconds = config.focus_delay_seconds,
  })

  return {
    start = function()
      esc.start()
      focus.start()
    end,
    stop = function()
      focus.stop()
      esc.stop()
    end,
  }
end

M.create = create
return M
