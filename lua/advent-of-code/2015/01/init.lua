local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "01")

function M:solve1()
  local floor = 0
  for c in self.input[1]:gmatch "." do
    if c == "(" then
      floor = floor + 1
    elseif c == ")" then
      floor = floor - 1
    end
  end
  self.solution:add("one", floor)
end

function M:solve2()
  local floor = 0
  local index = 0
  for c in self.input[1]:gmatch "." do
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
  self.solution:add("two", index)
end

M:run(false)

return M
