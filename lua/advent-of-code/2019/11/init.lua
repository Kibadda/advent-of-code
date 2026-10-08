--- @class AOCDay201911: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "11")

require "advent-of-code.2019.intcoder"

function M:solver(start)
  local grid = { { start } }
  local dir = V(-1, 0)
  local pos = V(1, 1)
  local painting = true

  Intcoder(self.input[1])
    :on_input(function()
      return { grid[pos.x] and grid[pos.x][pos.y] == "#" and 1 or 0 }
    end)
    :on_output(function(output)
      if painting then
        grid[pos.x] = grid[pos.x] or {}
        grid[pos.x][pos.y] = output == 0 and "." or "#"
        painting = false
      else
        dir = dir * (output == 0 and "L" or "R")
        pos = pos + dir
        painting = true
      end
    end)
    :run()

  return grid
end

function M:solve1()
  local grid = self:solver "."

  local count = 0
  for _, row in pairs(grid) do
    count = count + table.count(row)
  end

  return count
end

function M:solve2()
  local grid = self:solver "#"

  for _, row in ipairs(grid) do
    for i = 1, 5 do
      if not row[i] then
        row[i] = "."
      end
    end

    print(table.concat(row))
  end
end

M:run()
