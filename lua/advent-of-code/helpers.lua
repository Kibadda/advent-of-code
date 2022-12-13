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
  for k, v in pairs(t) do
    s = s .. (" "):rep(level * 2)
    if type(k) ~= "number" then
      s = s .. k .. " = "
    end
    if type(v) == "table" then
      s = s .. table.to_string(v, level + 1) .. ",\n"
    else
      s = s .. v .. ",\n"
    end
  end

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

function table.find(t, pos)
  for i, p in pairs(t) do
    if p.x == pos.x and p.y == pos.y then
      return i
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
