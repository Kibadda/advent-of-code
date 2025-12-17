--- @class AOCDay201801: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2018", "01")

function M:solve1()
  return table.reduce(self.input, 0, function(carry, i)
    return carry + tonumber(i)
  end)
end

function M:solve2()
  local seen = {}
  local frequency = 0
  for _, i in cycle(self.input) do
    frequency = frequency + i
    if seen[frequency] then
      break
    end
    seen[frequency] = true
  end

  return frequency
end

M:run()
