local M = {}

local function fail(message)
  error(message, 3)
end

local function resolve_label(label, default_label)
  if label == nil or label == "" then
    return default_label
  end
  return label
end

function M.expect_table(value, label)
  local resolved_label = resolve_label(label, "value")
  if type(value) ~= "table" then
    fail(string.format("%s must be a table", resolved_label))
  end
end

function M.expect_string(value, label)
  local resolved_label = resolve_label(label, "value")
  if type(value) ~= "string" then
    fail(string.format("%s must be a string", resolved_label))
  end
end

function M.expect_optional_number(value, label)
  if value ~= nil and type(value) ~= "number" then
    local resolved_label = resolve_label(label, "value")
    fail(string.format("%s must be a number when provided", resolved_label))
  end
end

function M.expect_optional_string(value, label)
  if value ~= nil and type(value) ~= "string" then
    local resolved_label = resolve_label(label, "value")
    fail(string.format("%s must be a string when provided", resolved_label))
  end
end

return M
