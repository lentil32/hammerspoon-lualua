local M = {}

local function normalize_app_name(app_name)
  if app_name == nil then
    return nil
  end
  if type(app_name) ~= "string" then
    return nil
  end
  return app_name
end

local function build_target_app_set(target_apps)
  local target_app_set = {}
  for _, target_app in ipairs(target_apps) do
    target_app_set[target_app] = true
  end
  return target_app_set
end

local function create(options)
  local target_app_set = build_target_app_set(options.target_apps)

  local function is_target_app(app_name)
    local normalized_app_name = normalize_app_name(app_name)
    if normalized_app_name == nil then
      return false
    end
    return target_app_set[normalized_app_name] == true
  end

  return {
    is_target_app = is_target_app,
  }
end

M.create = create
return M
