--- @class AOCDay202101: AOCDay
--- @field input integer[]
local M = require("advent-of-code.AOCDay"):new("2021", "01")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, tonumber(line))
  end
end

function M:solve1()
  local increases = 0

  table.reduce(self.input, math.huge, function(last, current)
    if last < current then
      increases = increases + 1
    end
    return current
  end)

  return increases
end

function M:solve2()
  local increases = 0

  table.reduce(table.windows(self.input, 3), math.huge, function(last, current)
    local sum = table.sum(current)

    if last < sum then
      increases = increases + 1
    end

    return sum
  end)

  return increases
end

M:run()
