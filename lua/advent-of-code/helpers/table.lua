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

---@generic T
---@param t T
---@return T
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
---@param start_value T
---@param func fun(carry: T, v: V, k: K): T
---@param iter? function
---@return T
function table.reduce(t, start_value, func, iter)
  local current = start_value
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
---@return table<K, T>
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

---@generic V
---@param t table<any, V>
---@param iter? function
---@return table<V, integer>
function table.frequencies(t, iter)
  iter = iter or ipairs

  local tmp = {}
  for _, v in iter(t) do
    tmp[v] = (tmp[v] or 0) + 1
  end

  return tmp
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

---@generic V: integer|string|boolean
---@param t V[]
---@param item V
---@return boolean
function table.contains(t, item)
  return table.reduce(t, false, function(carry, i)
    return carry or i == item
  end)
end

---@param length integer
---@param start? integer
function table.range(length, start)
  start = start or 1

  local t = {}
  for i = start, length do
    t[#t + 1] = i
  end

  return t
end

---@generic V
---@param t1 V[]
---@param t2 V[]
---@return V[]
function table.intersection(t1, t2)
  local t = {}

  for _, v in pairs(t1) do
    if table.contains(t2, v) then
      t[#t + 1] = v
    end
  end

  return t
end
