--- @class AOCDay202401: AOCDay
--- @field input { left: integer[], right: integer[] }
local M = require("advent-of-code.AOCDay"):new("2024", "01")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    left = {},
    right = {},
  }

  for _, line in ipairs(lines) do
    local left, right = unpack(line:only_ints())
    table.insert(self.input.left, left)
    table.insert(self.input.right, right)
  end
end

function M:solve1()
  table.sort(self.input.left)
  table.sort(self.input.right)

  local diff = 0
  for i = 1, #self.input.left do
    diff = diff + math.abs(self.input.left[i] - self.input.right[i])
  end

  return diff
end

function M:solve2()
  return table.reduce(self.input.left, 0, function(similarity, i)
    return similarity + i * #table.filter(self.input.right, function(j)
      return i == j
    end)
  end)
end

M:run()
