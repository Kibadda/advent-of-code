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
