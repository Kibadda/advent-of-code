function string:split(sep)
  sep = sep or "%s"
  local t = {}
  for str in self:gmatch("([^" .. sep .. "]+)") do
    table.insert(t, str)
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
