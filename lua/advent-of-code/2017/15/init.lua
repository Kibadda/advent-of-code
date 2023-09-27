local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "15")

function M:parse_input(file)
  self.input = {}
  for line in file:lines() do
    self.input[#self.input + 1] = line:only_ints()[1]
  end
end

function M:solver(rounds, fun)
  local input = table.deepcopy(self.input)
  local same = 0
  for _ = 1, rounds do
    fun(input)
    if bit.band(input[1], 0xFFFF) == bit.band(input[2], 0xFFFF) then
      same = same + 1
    end
  end
  return same
end

function M:solve1()
  self.solution:add(
    "1",
    self:solver(40000000, function(input)
      input[1] = (input[1] * 16807) % 2147483647
      input[2] = (input[2] * 48271) % 2147483647
    end)
  )
end

function M:solve2()
  self.solution:add(
    "2",
    self:solver(5000000, function(input)
      repeat
        input[1] = (input[1] * 16807) % 2147483647
      until input[1] % 4 == 0
      repeat
        input[2] = (input[2] * 48271) % 2147483647
      until input[2] % 8 == 0
    end)
  )
end

M:run()

return M
