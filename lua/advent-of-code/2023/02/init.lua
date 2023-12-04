local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2023", "02")

function M:parse_input(file)
  self.input = {}

  for line in file:lines() do
    local hands = line:split(":")[2]:split ";"

    local game = {}

    for _, hand in ipairs(hands) do
      local cubes = hand:split ","

      local t = {}

      for _, cube in ipairs(cubes) do
        local split = cube:split()

        t[split[2]] = tonumber(split[1])
      end

      table.insert(game, t)
    end

    table.insert(self.input, game)
  end
end

function M:solve1()
  local sum = 0

  for i, game in ipairs(self.input) do
    local possible = true

    for _, hand in ipairs(game) do
      if (hand.red and hand.red > 12) or (hand.green and hand.green > 13) or (hand.blue and hand.blue > 14) then
        possible = false
        break
      end
    end

    if possible then
      sum = sum + i
    end
  end

  self.solution:add("1", sum)
end

function M:solve2()
  local power = 0

  for _, game in ipairs(self.input) do
    local min = {
      red = 0,
      green = 0,
      blue = 0,
    }

    for _, hand in ipairs(game) do
      min = {
        red = math.max(min.red, hand.red or 0),
        green = math.max(min.green, hand.green or 0),
        blue = math.max(min.blue, hand.blue or 0),
      }
    end

    power = power + (min.red * min.green * min.blue)
  end

  self.solution:add("2", power)
end

M:run()

return M
