local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "02")

function M:solve1()
  local total_square_feet = 0

  for _, line in ipairs(self.input) do
    local split = line:split "x"
    local length, width, height = tonumber(split[1]), tonumber(split[2]), tonumber(split[3])

    local one = length * width
    local two = width * height
    local three = height * length

    total_square_feet = total_square_feet + 2 * one + 2 * two + 2 * three + math.min(one, two, three)
  end

  self.solution:add("1", total_square_feet)
end

function M:solve2()
  local total_feet = 0

  for _, line in ipairs(self.input) do
    local split = line:split "x"
    local length, width, height = tonumber(split[1]), tonumber(split[2]), tonumber(split[3])

    local t = { length, width, height }
    table.sort(t)
    total_feet = total_feet + 2 * t[1] + 2 * t[2] + t[1] * t[2] * t[3]
  end

  self.solution:add("2", total_feet)
end

M:run()

return M
