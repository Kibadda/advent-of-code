local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "01")

function M:solver(fun)
  local floor = 0
  for i, c in ipairs(self.input[1]:to_list()) do
    if c == "(" then
      floor = floor + 1
    elseif c == ")" then
      floor = floor - 1
    end
    if fun and fun(floor) then
      return i
    end
  end
  return floor
end

function M:solve1()
  self.solution:add("1", self:solver())
end

function M:solve2()
  self.solution:add(
    "2",
    self:solver(function(floor)
      return floor < 0
    end)
  )
end

M:run()

return M
