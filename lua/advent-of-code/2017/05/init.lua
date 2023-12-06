local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "05")

function M:parse(file)
  self.input = {}
  for line in file:lines() do
    self.input[#self.input + 1] = tonumber(line)
  end
end

function M:solver(fun)
  local jumps = table.deepcopy(self.input)
  local index = 1
  local steps = 0
  while jumps[index] do
    local new = index + jumps[index]
    jumps[index] = fun(jumps[index])
    index = new
    steps = steps + 1
  end
  return steps
end

function M:solve1()
  self.solution:add(
    "1",
    self:solver(function(jump)
      return jump + 1
    end)
  )
end

function M:solve2()
  self.solution:add(
    "2",
    self:solver(function(jump)
      return jump >= 3 and jump - 1 or jump + 1
    end)
  )
end

M:run()

return M
