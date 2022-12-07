local AOCDay = require "advent-of-code.AOCDay"

local M = AOCDay:new("2015", "01")

function M:solve1()
  local floor = 0
  for c in self.lines[1]:gmatch "." do
    if c == "(" then
      floor = floor + 1
    elseif c == ")" then
      floor = floor - 1
    end
  end
  return floor
end

function M:solve2()
  local floor = 0
  local index = 0
  for c in self.lines[1]:gmatch "." do
    index = index + 1
    if c == "(" then
      floor = floor + 1
    elseif c == ")" then
      floor = floor - 1
    end
    if floor < 0 then
      break
    end
  end
  return index
end

return M
