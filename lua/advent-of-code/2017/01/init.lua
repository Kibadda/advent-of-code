--- @class AOCDay201701: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2017", "01")

--- @param lines string[]
function M:parse(lines)
  self.input = lines[1]
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
  return self:solver(function(i)
    return i + 1 > #self.input and 1 or i + 1
  end)
end

function M:solve2()
  return self:solver(function(i)
    local next = i + #self.input / 2
    return next > #self.input and next - #self.input or next
  end)
end

M:run()
