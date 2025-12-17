--- @class AOCDay201518: AOCDay
--- @field input string[][]
local M = require("advent-of-code.AOCDay"):new("2015", "18")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:to_list())
  end
end

function M:solver(steps, corners_broken)
  local function count_lights(v, grid)
    return table.reduce(
      {
        v + V(-1, 0),
        v + V(-1, 1),
        v + V(0, 1),
        v + V(1, 1),
        v + V(1, 0),
        v + V(1, -1),
        v + V(0, -1),
        v + V(-1, -1),
      },
      0,
      function(carry, p)
        return carry + ((grid[p.x] and grid[p.x][p.y] and grid[p.x][p.y] == "#") and 1 or 0)
      end
    )
  end

  local grid = table.deepcopy(self.input)
  for _ = 1, steps do
    local new = table.deepcopy(grid)
    for i, row in ipairs(grid) do
      for j, c in ipairs(row) do
        if not corners_broken or not ((i == 1 or i == #grid) and (j == 1 or j == #row)) then
          local lights = count_lights(V(i, j), grid)
          match(c) {
            ["."] = function()
              if lights == 3 then
                new[i][j] = "#"
              end
            end,
            ["#"] = function()
              if lights < 2 or lights > 3 then
                new[i][j] = "."
              end
            end,
          }
        end
      end
    end
    grid = new
  end

  return table.reduce(grid, 0, function(carry_1, row)
    return carry_1 + table.reduce(row, 0, function(carry_2, c)
      return carry_2 + (c == "#" and 1 or 0)
    end)
  end)
end

function M:solve1()
  return self:solver(self.test and 4 or 100, false)
end

function M:solve2()
  self.input[1][1] = "#"
  self.input[1][#self.input[1]] = "#"
  self.input[#self.input][1] = "#"
  self.input[#self.input][#self.input[#self.input]] = "#"
  return self:solver(self.test and 5 or 100, true)
end

M:run()
