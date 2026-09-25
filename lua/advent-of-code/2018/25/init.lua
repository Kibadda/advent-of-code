--- @class AOCDay201825: AOCDay
--- @field input integer[][]
local M = require("advent-of-code.AOCDay"):new("2018", "25")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:only_ints "-?%d+")
  end
end

function M:solve1()
  local constellations = {}

  for _, point in ipairs(self.input) do
    local found = {}

    for i, c in ipairs(constellations) do
      for _, p in ipairs(c) do
        if
          math.abs(p[1] - point[1])
            + math.abs(p[2] - point[2])
            + math.abs(p[3] - point[3])
            + math.abs(p[4] - point[4])
          <= 3
        then
          table.insert(found, i)
          break
        end
      end
    end

    if #found == 0 then
      table.insert(constellations, { point })
    else
      local constellation = {}
      table.sort(found, function(a, b)
        return a > b
      end)
      for _, index in ipairs(found) do
        for _, p in ipairs(table.remove(constellations, index)) do
          table.insert(constellation, p)
        end
      end
      table.insert(constellation, point)
      table.insert(constellations, constellation)
    end
  end

  return #constellations
end

function M:solve2() end

M:run()
