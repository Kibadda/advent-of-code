--- @class AOCDay202410: AOCDay
--- @field input { grid: integer[][], trailheads: Vector[] }
local M = require("advent-of-code.AOCDay"):new("2024", "10")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    grid = {},
    trailheads = {},
  }

  for i, line in ipairs(lines) do
    table.insert(
      self.input.grid,
      table.map(line:to_list(), function(c, j)
        if c == "0" then
          table.insert(self.input.trailheads, V(i, j))
        end
        return tonumber(c)
      end)
    )
  end
end

--- @param count_finishes boolean
function M:solver(count_finishes)
  return table.reduce(self.input.trailheads, 0, function(sum, head)
    local score = 0
    local finishes = {}

    treesearch {
      start = head,
      depth = true,
      compare = function()
        return true
      end,
      --- @param current Vector
      exit = function(current)
        if self.input.grid[current.x][current.y] == 9 then
          finishes[current:string()] = true
          score = score + 1

          return true
        end

        return false
      end,
      --- @param current Vector
      step = function(current)
        local steps = {}

        for _, pos in ipairs(current:adjacent(4)) do
          if self.input.grid[pos.x] and self.input.grid[pos.x][pos.y] == self.input.grid[current.x][current.y] + 1 then
            table.insert(steps, pos)
          end
        end

        return steps
      end,
    }

    return sum + (count_finishes and table.count(finishes) or score)
  end)
end

function M:solve1()
  return self:solver(true)
end

function M:solve2()
  return self:solver(false)
end

M:run()
