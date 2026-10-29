--- @class AOCDay201924: AOCDay
--- @field input ("#"|".")[][]
local M = require("advent-of-code.AOCDay"):new("2019", "24")

--- @param lines string[]
function M:parse(lines)
  self.input = {}

  for _, line in ipairs(lines) do
    table.insert(self.input, line:to_list())
  end
end

function M:solve1()
  local seen = {}
  local grid = table.deepcopy(self.input)

  while true do
    local hash = table.concat(table.map(grid, function(row)
      return table.concat(row)
    end))

    if seen[hash] then
      break
    end

    seen[hash] = true

    local new_grid = {}

    for i, row in ipairs(grid) do
      new_grid[i] = {}
      for j, cell in ipairs(row) do
        local adjacent_bugs = table.reduce(V(i, j):adjacent(4), 0, function(sum, pos)
          if grid[pos.x] and grid[pos.x][pos.y] == "#" then
            return sum + 1
          end

          return sum
        end)

        if cell == "#" then
          new_grid[i][j] = adjacent_bugs == 1 and "#" or "."
        elseif cell == "." then
          new_grid[i][j] = (adjacent_bugs == 1 or adjacent_bugs == 2) and "#" or "."
        end
      end
    end

    grid = new_grid
  end

  return table.reduce(table.flatten(grid), 0, function(biodiversity, cell, i)
    if cell == "#" then
      return biodiversity + math.pow(2, i - 1)
    end

    return biodiversity
  end)
end

function M:solve2()
  --
end

M:run()
