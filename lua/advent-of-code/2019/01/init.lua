--- @class AOCDay201901: AOCDay
--- @field input integer[]
local M = require("advent-of-code.AOCDay"):new("2019", "01")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, tonumber(line))
  end
end

function M:solver(mass)
  return math.floor(mass / 3) - 2
end

function M:solve1()
  return table.reduce(self.input, 0, function(fuel, mass)
    return fuel + self:solver(mass)
  end)
end

function M:solve2()
  return table.reduce(self.input, 0, function(fuel, mass)
    local current = mass

    while true do
      local f = self:solver(current)

      if f <= 0 then
        break
      end

      fuel = fuel + f
      current = f
    end

    return fuel
  end)
end

M:run()
