function string:split(sep)
  sep = sep or "%s"
  local t = {}
  for str in self:gmatch("([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function string:to_list()
  local t = {}
  for c in self:gmatch "." do
    table.insert(t, c)
  end
  return t
end

function table.to_string(t, level)
  level = level ~= nil and level or 1

  local s = "{\n"
  local test = {}
  for k, v in pairs(t) do
    local test_string = (" "):rep(level * 2)
    if type(k) ~= "number" then
      test_string = test_string .. k .. " = "
    end
    if type(v) == "table" then
      test_string = test_string .. table.to_string(v, level + 1) .. ",\n"
    elseif type(v) == "boolean" then
      test_string = test_string .. (v and "true" or "false") .. ",\n"
    else
      test_string = test_string .. v .. ",\n"
    end
    table.insert(test, test_string)
  end

  s = s .. table.concat(test, "\n")

  s = s .. (" "):rep((level - 1) * 2) .. "}"

  return s
end

function table.count(t)
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

function table.find(t, needle, keys)
  keys = keys or { "x", "y" }
  if type(keys) ~= "table" then
    keys = { keys }
  end

  for i, item in pairs(t) do
    if type(item) == "table" then
      local check = true
      for _, key in ipairs(keys) do
        check = check and item[key] == needle[key]
      end
      if check then
        return i
      end
    else
      if needle == item then
        return i
      end
    end
  end

  return nil
end

function table.count_uniques(t)
  local tmp = {}
  for _, v in ipairs(t) do
    tmp[v] = true
  end
  return table.count(tmp)
end

function table.deepcopy(t)
  local orig_type = type(t)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in next, t, nil do
      copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
    end
    setmetatable(copy, table.deepcopy(getmetatable(t)))
  else
    copy = t
  end
  return copy
end

function table.filter(t, func)
  local tmp = {}
  for k, v in pairs(t) do
    if func(v, k) then
      tmp[k] = v
    end
  end
  return tmp
end
