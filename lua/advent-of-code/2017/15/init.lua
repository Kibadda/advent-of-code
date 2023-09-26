local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "15")

function M:parse_input(file)
  self.input = {}
  for line in file:lines() do
    self.input[#self.input + 1] = line:only_ints()[1]
  end
end

function M:solve1()
  local input = table.deepcopy(self.input)
  local same = 0
  for _ = 1, 40000000 do
    input[1] = (input[1] * 16807) % 2147483647
    input[2] = (input[2] * 48271) % 2147483647

    if bit.band(input[1], 0xFFFF) == bit.band(input[2], 0xFFFF) then
      same = same + 1
    end
  end
  self.solution:add("1", same)
end

function M:solve2()
  local input = table.deepcopy(self.input)
  local same = 0
  for _ = 1, 5000000 do
    repeat
      input[1] = (input[1] * 16807) % 2147483647
    until input[1] % 4 == 0
    repeat
      input[2] = (input[2] * 48271) % 2147483647
    until input[2] % 8 == 0

    if bit.band(input[1], 0xFFFF) == bit.band(input[2], 0xFFFF) then
      same = same + 1
    end
  end
  self.solution:add("2", same)
end

M:run()

return M
