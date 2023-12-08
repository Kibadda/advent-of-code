local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay201501: AOCDay
---@field input string[]
local M = AOC.create("2015", "01")

---@param func? fun(floor: integer): boolean
function M:solver(func)
  local floor = 0

  for i, c in ipairs(self.input[1]:to_list()) do
    if c == "(" then
      floor = floor + 1
    elseif c == ")" then
      floor = floor - 1
    end
    if func and func(floor) then
      return i
    end
  end

  return floor
end

function M:solve1()
  return self:solver()
end

function M:solve2()
  return self:solver(function(floor)
    return floor < 0
  end)
end

M:run()

return M
