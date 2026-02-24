--- @class AOCDay202002: AOCDay
--- @field input { lower: integer, upper: integer, character: string, password: string }[]
local M = require("advent-of-code.AOCDay"):new("2020", "02")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local lower, upper, character, password = line:match "^([%d]+)%-([%d]+) (.): (.*)$"

    table.insert(self.input, {
      lower = tonumber(lower),
      upper = tonumber(upper),
      character = character,
      password = password,
    })
  end
end

function M:solve1()
  return table.reduce(self.input, 0, function(count, pass)
    local c = pass.password:count(pass.character)

    if c >= pass.lower and c <= pass.upper then
      return count + 1
    end

    return count
  end)
end

function M:solve2()
  return table.reduce(self.input, 0, function(count, pass)
    local t = 0

    if pass.password:at(pass.lower) == pass.character then
      t = t + 1
    end
    if pass.password:at(pass.upper) == pass.character then
      t = t + 1
    end

    return count + (t == 1 and 1 or 0)
  end)
end

M:run()
