local M = {}

local function create(options)
  local keycodes = options.keycodes
  local english_layout_name = options.english_layout_name
  local english_source_id = options.english_source_id

  local function set_input_source_to_english()
    if english_source_id ~= nil and keycodes.currentSourceID() == english_source_id then
      return
    end

    if english_source_id == nil and keycodes.currentLayout() == english_layout_name then
      return
    end

    if keycodes.setLayout(english_layout_name) == true then
      return
    end

    if english_source_id ~= nil then
      keycodes.currentSourceID(english_source_id)
    end
  end

  return {
    set_input_source_to_english = set_input_source_to_english,
  }
end

M.create = create
return M
