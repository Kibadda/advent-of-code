--- @class AOCDay202003: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2020", "03")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:to_list())
  end
end

--- @param slope Vector
function M:solver(slope)
  local pos = V(1, 1)
  local trees = 0

  while pos.x <= #self.input do
    if self.input[pos.x][pos.y] == "#" then
      trees = trees + 1
    end

    pos.y = pos.y + slope.y
    if pos.y > #self.input[pos.x] then
      pos.y = pos.y - #self.input[pos.x]
    end
    pos.x = pos.x + slope.x
  end

  return trees
end

function M:solve1()
  return self:solver(V(1, 3))
end

function M:solve2()
  return table.reduce({ V(1, 1), V(1, 3), V(1, 5), V(1, 7), V(2, 1) }, 1, function(trees, slope)
    return trees * self:solver(slope)
  end)
end

M:run()
