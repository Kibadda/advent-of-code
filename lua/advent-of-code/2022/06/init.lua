local AOCDay = require "advent-of-code.AOCDay"

local M = AOCDay:new("2022", "06")

function table.count_uniques(t)
  local tmp = {}
  for _, v in ipairs(t) do
    tmp[v] = true
  end
  return table.count(tmp)
end

function M:solve1()
  local buffer = {}
  local index = 0
  for c in self.lines[1]:gmatch "." do
    if #buffer >= 4 then
      table.remove(buffer, 1)
    end
    table.insert(buffer, c)

    index = index + 1

    if index > 3 and table.count_uniques(buffer) == 4 then
      break
    end
  end

  return index
end

function M:solve2()
  local buffer = {}
  local index = 0
  for c in self.lines[1]:gmatch "." do
    if #buffer >= 14 then
      table.remove(buffer, 1)
    end
    table.insert(buffer, c)

    index = index + 1

    if index > 13 and table.count_uniques(buffer) == 14 then
      break
    end
  end

  return index
end

return M
