local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "05")

function M:parse_input(file)
  self.input = {}
  for line in file:lines() do
    self.input[#self.input + 1] = tonumber(line)
  end
end

function M:solve1()
  local jumps = table.deepcopy(self.input)
  local index = 1
  local steps = 0
  while jumps[index] do
    local new = index + jumps[index]
    jumps[index] = jumps[index] + 1
    index = new
    steps = steps + 1
  end
  self.solution:add("1", steps)
end

function M:solve2()
  local jumps = table.deepcopy(self.input)
  local index = 1
  local steps = 0
  while jumps[index] do
    local new = index + jumps[index]
    if jumps[index] >= 3 then
      jumps[index] = jumps[index] - 1
    else
      jumps[index] = jumps[index] + 1
    end
    index = new
    steps = steps + 1
  end
  self.solution:add("2", steps)
end

M:run()

return M
