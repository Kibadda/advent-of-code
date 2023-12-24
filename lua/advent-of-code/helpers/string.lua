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
---@return string[]
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
---@param pattern? string
function string.only_ints(str, pattern)
  local t = {}
  pattern = pattern or "%d+"
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

---@param s string
---@param pattern string
---@param init? integer
---@param plain? boolean
function string.reversefind(s, pattern, init, plain)
  return string.find(s:reverse(), pattern:reverse(), init, plain)
end

---@param s string
---@param prefix string
function string.startswith(s, prefix)
  return s:sub(1, #prefix) == prefix
end

---@param s string
---@param pattern string
function string.count(s, pattern)
  local count = 0

  ---@type integer?
  local index = 0

  while true do
    index = s:find(pattern, index + 1)
    if not index then
      break
    end
    count = count + 1
  end

  return count
end
