local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2018", "01")

function M:solve1()
  self.solution:add(
    "1",
    table.reduce(self.input, 0, function(carry, i)
      return carry + tonumber(i)
    end)
  )
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

  self.solution:add("2", frequency)
end

M:run()

return M
