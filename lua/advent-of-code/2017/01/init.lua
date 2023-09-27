local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "01")

function M:parse_input(file)
  for line in file:lines() do
    self.input = line
  end
end

function M:solver(fun)
  local sum = 0
  for i = 1, #self.input do
    if self.input:at(i) == self.input:at(fun(i)) then
      sum = sum + tonumber(self.input:at(i))
    end
  end
  return sum
end

function M:solve1()
  self.solution:add(
    "1",
    self:solver(function(i)
      return i + 1 > #self.input and 1 or i + 1
    end)
  )
end

function M:solve2()
  self.solution:add(
    "2",
    self:solver(function(i)
      local next = i + #self.input / 2
      return next > #self.input and next - #self.input or next
    end)
  )
end

M:run()

return M
