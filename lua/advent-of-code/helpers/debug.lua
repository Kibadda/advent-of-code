local old_tostring = tostring
function _G.tostring(v)
  if type(v) == "table" then
    return old_tostring(table.to_string(v))
  elseif type(v) == "number" then
    return old_tostring(string.format("%d", v))
  else
    return old_tostring(v)
  end
end

--- @param t table
--- @param level? integer
function table.to_string(t, level)
  level = level ~= nil and level or 1

  local s = "{\n"
  local test = {}
  for k, v in spairs(t) do
    local test_string = (" "):rep(level * 2)
    test_string = test_string .. k .. " = "
    if type(v) == "table" then
      test_string = test_string .. table.to_string(v, level + 1) .. ",\n"
    elseif type(v) == "boolean" then
      test_string = test_string .. (v and "true" or "false") .. ",\n"
    elseif type(v) == "function" then
      test_string = test_string .. "function,\n"
    else
      test_string = test_string .. v .. ",\n"
    end
    table.insert(test, test_string)
  end

  s = s .. table.concat(test, "")

  s = s .. (" "):rep((level - 1) * 2) .. "}"

  return s
end
