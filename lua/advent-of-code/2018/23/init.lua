--- @class AOCDay201823: AOCDay
--- @field input { bounds: { min: integer[], max: integer[] }, bots: integer[][] }
local M = require("advent-of-code.AOCDay"):new("2018", "23")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    bounds = {
      min = { math.huge, math.huge, math.huge },
      max = { -math.huge, -math.huge, -math.huge },
    },
    bots = {},
  }

  for _, line in ipairs(lines) do
    local ints = line:only_ints "-?%d+"

    self.input.bounds = {
      min = {
        math.min(self.input.bounds.min[1], ints[1]),
        math.min(self.input.bounds.min[2], ints[2]),
        math.min(self.input.bounds.min[3], ints[3]),
      },
      max = {
        math.max(self.input.bounds.max[1], ints[1]),
        math.max(self.input.bounds.max[2], ints[2]),
        math.max(self.input.bounds.max[3], ints[3]),
      },
    }

    table.insert(self.input.bots, ints)
  end
end

local function manhattan(a, b)
  return math.abs(a[1] - b[1]) + math.abs(a[2] - b[2]) + math.abs(a[3] - b[3])
end

function M:solve1()
  local strongest = table.reduce(self.input.bots, self.input.bots[1], function(carry, nano)
    if nano[4] > carry[4] then
      return nano
    end

    return carry
  end)

  local range = table.reduce(self.input.bots, 0, function(carry, nano)
    if manhattan(nano, strongest) <= strongest[4] then
      return carry + 1
    end

    return carry
  end)

  return range
end

function M:solve2()
  local q = {}

  for _, bot in ipairs(self.input.bots) do
    local d = math.abs(bot[1]) + math.abs(bot[2]) + math.abs(bot[3])
    table.insert(q, { math.max(0, d - bot[4]), 1 })
    table.insert(q, { d + bot[4] + 1, -1 })
  end

  table.sort(q, function(a, b)
    return a[1] > b[1]
  end)

  local count = 0
  local maxCount = 0
  local result = 0

  while #q > 0 do
    local b = table.remove(q)
    count = count + b[2]
    if count > maxCount then
      result = b[1]
      maxCount = count
    end
  end

  return result
end

M:run()
