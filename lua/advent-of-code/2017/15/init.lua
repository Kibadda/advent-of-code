--- @class AOCDay201715: AOCDay
--- @field input integer[]
local M = require("advent-of-code.AOCDay"):new("2017", "15")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:only_ints()[1])
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
  return self:solver(40000000, function(input)
    input[1] = (input[1] * 16807) % 2147483647
    input[2] = (input[2] * 48271) % 2147483647
  end)
end

function M:solve2()
  return self:solver(5000000, function(input)
    repeat
      input[1] = (input[1] * 16807) % 2147483647
    until input[1] % 4 == 0
    repeat
      input[2] = (input[2] * 48271) % 2147483647
    until input[2] % 8 == 0
  end)
end

M:run()
