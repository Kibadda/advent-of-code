local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "01")

function M:parse_input(file)
  for line in file:lines() do
    self.input = line
  end
end

function M:solve1()
  local sum = 0
  for i = 1, #self.input do
    local next = i + 1
    if next > #self.input then
      next = 1
    end
    if self.input:at(i) == self.input:at(next) then
      sum = sum + tonumber(self.input:at(i))
    end
  end
  self.solution:add("1", sum)
end

function M:solve2()
  local sum = 0
  for i = 1, #self.input do
    local next = i + #self.input / 2
    if next > #self.input then
      next = next - #self.input
    end
    if self.input:at(i) == self.input:at(next) then
      sum = sum + tonumber(self.input:at(i))
    end
  end
  self.solution:add("2", sum)
end

M:run(false)

return M
