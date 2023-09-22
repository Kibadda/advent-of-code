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

---@param str string
---@param sep string
function string.split(str, sep)
  sep = sep or "%s"
  local t = {}
  for s in str:gmatch("([^" .. sep .. "]+)") do
    table.insert(t, s)
  end
  return t
end

---@param str string
function string.trim(str)
  str = str:gsub("^%s+", ""):gsub("%s+$", "")
  return str
end

---@param str string
---@param length integer
function string.to_chunks(str, length)
  local t = {}
  for c in str:gmatch(("."):rep(length)) do
    table.insert(t, c)
  end
  return t
end

---@param str string
---@param func? fun(c: string): boolean
function string.to_list(str, func)
  local t = {}
  for c in str:gmatch "." do
    if func == nil or func(c) then
      table.insert(t, c)
    end
  end
  return t
end

---@param str string
---@param with_negatives boolean
function string.only_ints(str, with_negatives)
  local t = {}
  local pattern = "%d+"
  if with_negatives then
    pattern = "-?%d+"
  end
  for num in str:gmatch(pattern) do
    table.insert(t, tonumber(num))
  end
  return t
end

---@param str string
---@param n integer
function string.fill(str, n)
  while #str < n do
    str = " " .. str
  end
  return str
end

---@param str string
---@param pos integer
function string.at(str, pos)
  return pos <= #str and str:sub(pos, pos) or nil
end

---@param t table
---@param level? integer
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

---@param t table
---@return integer
function table.count(t)
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

---@generic T
---@param t T[]
---@param needle T
---@param keys? table
---@return T?
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

---@param t table
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

---@generic K
---@generic V
---@param t table<K, V>
---@param func fun(v: V, k: K): boolean
---@param keep_index? boolean
---@param iter? function
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

---@generic K, V, T
---@param t table<K, V>
---@param func fun(carry: T, v: V, k: K): T
---@param start_value T
---@param iter? function
---@return T
function table.reduce(t, start_value, func, iter)
  local current = start_value or 0
  iter = iter or ipairs

  for k, v in iter(t) do
    current = func(current, v, k)
  end

  return current
end

---@generic K, V, T
---@param t table<K, V>
---@param func fun(v: V, k: K): T
---@param iter? function
---@return T[]
function table.map(t, func, iter)
  iter = iter or ipairs

  local tmp = {}
  for k, v in iter(t) do
    tmp[k] = func(v, k)
  end

  return tmp
end

---@generic K
---@param t table<K, any>
---@param iter? function
---@return K[]
function table.keys(t, iter)
  iter = iter or pairs

  local tmp = {}
  for k in iter(t) do
    table.insert(tmp, k)
  end

  return tmp
end

---@generic V
---@param t V[]
---@param iter? function
---@return V[]
function table.values(t, iter)
  iter = iter or pairs

  local tmp = {}
  for _, v in iter(t) do
    table.insert(tmp, v)
  end

  return tmp
end

---@generic K, V, H, J
---@param t table<K, V>
---@param func fun(v: V, k: K): { [1]: H, [2]: J }
---@param iter? function
---@return table<H, J>
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

---@generic K, V
---@param t table<K, V>
---@return table<K, V>
function table.reverse(t)
  local tmp = {}

  for _, v in ipairs(t) do
    table.insert(tmp, 1, v)
  end

  return tmp
end

---@generic V
---@param t V[]
---@param size integer
---@return V[][]
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
