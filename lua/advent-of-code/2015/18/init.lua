local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "18")

function M:parse_input(file)
  for line in file:lines() do
    local row = {}
    for c in line:gmatch "." do
      table.insert(row, c)
    end
    table.insert(self.input, row)
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
  self.solution:add("1", self:solver(self.test and 4 or 100, false))
end

function M:solve2()
  self.input[1][1] = "#"
  self.input[1][#self.input[1]] = "#"
  self.input[#self.input][1] = "#"
  self.input[#self.input][#self.input[#self.input]] = "#"
  self.solution:add("2", self:solver(self.test and 5 or 100, true))
end

M:run()

return M
