--- @class AOCDay202512: AOCDay
--- @field input { area: number, quantities: number[] }[]
local M = require("advent-of-code.AOCDay"):new("2025", "12")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    if line:find "%d+x%d+:" ~= nil then
      local ints = line:only_ints()
      table.insert(self.input, {
        area = ints[1] * ints[2],
        quantities = { unpack(ints, 3) },
      })
    end
  end
end

function M:solve1()
  return table.reduce(self.input, 0, function(sum, tree)
    return sum + (table.sum(tree.quantities) * 9 <= tree.area and 1 or 0)
  end)
end

function M:solve2() end

M:run()
