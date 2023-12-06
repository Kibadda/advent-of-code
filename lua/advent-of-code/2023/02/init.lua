local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay202302: AOCDay
---@field input { red?: integer, green?: integer, blue?: integer }[][]
local M = AOC.create("2023", "02")

function M:parse_input(file)
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
  return table.reduce(self.input, 0, function(sum, game, i)
    return table.reduce(game, true, function(possible, hand)
      return possible
        and (not hand.red or hand.red <= 12)
        and (not hand.green or hand.green <= 13)
        and (not hand.blue or hand.blue <= 14)
    end) and sum + i or sum
  end)
end

function M:solve2()
  return table.reduce(self.input, 0, function(power, game)
    local min = table.reduce(game, { red = 0, green = 0, blue = 0 }, function(max, hand)
      return {
        red = math.max(max.red, hand.red or 0),
        green = math.max(max.green, hand.green or 0),
        blue = math.max(max.blue, hand.blue or 0),
      }
    end)

    return power + (min.red * min.green * min.blue)
  end)
end

M:run()

return M
