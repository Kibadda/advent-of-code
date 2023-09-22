---@param value integer|string|boolean
function _G.match(value)
  local function re(v)
    if type(v) == "function" then
      return v(value)
    else
      return v
    end
  end

  return function(cases)
    for k, v in pairs(cases) do
      if type(k) == "table" then
        for _, key in ipairs(k) do
          if key == value then
            return re(v)
          end
        end
      else
        if k == value then
          return re(v)
        end
      end
    end
    if cases._ then
      return re(cases._)
    end
  end
end

local old_tostring = tostring
function _G.tostring(v)
  if type(v) == "table" then
    return old_tostring(table.to_string(v))
  else
    return old_tostring(v)
  end
end

function string:split(sep)
  sep = sep or "%s"
  local t = {}
  for str in self:gmatch("([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function string:trim()
  return self:gsub("^%s+", ""):gsub("%s+$", "")
end

function string:to_chunks(length)
  local t = {}
  for c in self:gmatch(("."):rep(length)) do
    table.insert(t, c)
  end
  return t
end

function string:to_list(func)
  local t = {}
  for c in self:gmatch "." do
    if func == nil or func(c) then
      table.insert(t, c)
    end
  end
  return t
end

function string:only_ints(with_negatives)
  local t = {}
  local pattern = "%d+"
  if with_negatives then
    pattern = "-?%d+"
  end
  for num in self:gmatch(pattern) do
    table.insert(t, tonumber(num))
  end
  return t
end

function string:fill(n)
  while #self < n do
    self = " " .. self
  end
  return self
end

function string:at(pos)
  return pos <= #self and self:sub(pos, pos) or nil
end

function table.to_string(t, level)
  level = level ~= nil and level or 1

  local s = "{\n"
  local test = {}
  for k, v in pairs(t) do
    local test_string = (" "):rep(level * 2)
    test_string = test_string .. k .. " = "
    if type(v) == "table" then
      test_string = test_string .. table.to_string(v, level + 1) .. ",\n"
    elseif type(v) == "boolean" then
      test_string = test_string .. (v and "true" or "false") .. ",\n"
    else
      test_string = test_string .. v .. ",\n"
    end
    table.insert(test, test_string)
  end

  s = s .. table.concat(test, "")

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

function table.filter(t, func, keep_index, iter)
  local tmp = {}
  iter = iter or ipairs

  for k, v in iter(t) do
    if func(v, k) then
      if keep_index then
        tmp[k] = v
      else
        table.insert(tmp, v)
      end
    end
  end
  return tmp
end

function table.reduce(t, func, start_value, iter)
  local current = start_value or 0
  iter = iter or ipairs

  for k, v in iter(t) do
    current = func(current, v, k)
  end

  return current
end

function table.map(t, func, iter)
  iter = iter or ipairs

  local tmp = {}
  for k, v in iter(t) do
    tmp[k] = func(v, k)
  end

  return tmp
end

function table.keys(t, iter)
  iter = iter or pairs

  local tmp = {}
  for k in iter(t) do
    table.insert(tmp, k)
  end

  return tmp
end

function table.values(t, iter)
  iter = iter or pairs

  local tmp = {}
  for _, v in iter(t) do
    table.insert(tmp, v)
  end

  return tmp
end

function table.map_to_groups(t, func, iter)
  iter = iter or ipairs

  local tmp = {}
  for k, v in iter(t) do
    local s = func(v, k)
    tmp[s[1]] = tmp[s[1]] or {}
    table.insert(tmp[s[1]], s[2])
  end

  return tmp
end

function table.frequencies(t, func, iter)
  return table.map(table.map_to_groups(t, func, iter or ipairs), function(s)
    return table.count(s)
  end, pairs)
end

function table.reverse(t)
  local tmp = {}

  for _, v in ipairs(t) do
    table.insert(tmp, 1, v)
  end

  return tmp
end

function table.to_chunks(t, size)
  local tmp = {}
  local chunk = {}

  for _, v in ipairs(t) do
    table.insert(chunk, v)
    if #chunk == size then
      table.insert(tmp, chunk)
      chunk = {}
    end
  end

  return tmp
end
