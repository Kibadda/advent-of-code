--- @param str string
--- @param sep? string
--- @return string[]
function string.split(str, sep)
  sep = sep or "%s"
  local t = {}
  for s in str:gmatch("([^" .. sep .. "]+)") do
    table.insert(t, s)
  end
  return t
end

--- @param str string
function string.trim(str)
  str = str:gsub("^%s+", ""):gsub("%s+$", "")
  return str
end

--- @param str string
--- @param length integer
function string.to_chunks(str, length)
  local t = {}
  for c in str:gmatch(("."):rep(length)) do
    table.insert(t, c)
  end
  return t
end

--- @param str string
--- @param func? fun(c: string): boolean
--- @return string[]
function string.to_list(str, func)
  local t = {}
  for c in str:gmatch "." do
    if func == nil or func(c) then
      table.insert(t, c)
    end
  end
  return t
end

--- @param str string
--- @param pattern? string
function string.only_ints(str, pattern)
  local t = {}
  pattern = pattern or "%d+"
  for num in str:gmatch(pattern) do
    table.insert(t, tonumber(num))
  end
  return t
end

--- @param str string
--- @param n integer
function string.fill(str, n)
  while #str < n do
    str = " " .. str
  end
  return str
end

--- @param str string
--- @param pos integer
function string.at(str, pos)
  return pos <= #str and str:sub(pos, pos) or nil
end

--- @param s string
--- @param pattern string
--- @param init? integer
--- @param plain? boolean
function string.reversefind(s, pattern, init, plain)
  return string.find(s:reverse(), pattern:reverse(), init, plain)
end

--- @param s string
--- @param prefix string
function string.startswith(s, prefix)
  return s:sub(1, #prefix) == prefix
end

--- @param s string
--- @param pattern string
function string.count(s, pattern)
  local count = 0

  --- @type integer?
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

--- @param str1 string
--- @param str2 string
--- @return integer
function string.levenshtein(str1, str2)
  local len1 = string.len(str1)
  local len2 = string.len(str2)
  local matrix = {}
  local cost = 0

  -- quick cut-offs to save time
  if len1 == 0 then
    return len2
  elseif len2 == 0 then
    return len1
  elseif str1 == str2 then
    return 0
  end

  -- initialise the base matrix values
  for i = 0, len1, 1 do
    matrix[i] = {}
    matrix[i][0] = i
  end
  for j = 0, len2, 1 do
    matrix[0][j] = j
  end

  -- actual Levenshtein algorithm
  for i = 1, len1, 1 do
    for j = 1, len2, 1 do
      if str1:byte(i) == str2:byte(j) then
        cost = 0
      else
        cost = 1
      end

      matrix[i][j] = math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost)
    end
  end

  -- return the last value - this is the Levenshtein distance
  return matrix[len1][len2]
end
