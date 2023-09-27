local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "06")

function M:solver(functions)
  local grid = {}
  for i = 1, 1000 do
    grid[i] = grid[i] or {}
    for j = 1, 1000 do
      grid[i][j] = 0
    end
  end

  for _, line in ipairs(self.input) do
    local split = line:split()
    if split[1] == "turn" then
      local start_coor = split[3]:split ","
      local end_coor = split[5]:split ","
      if split[2] == "on" then
        for i = start_coor[1] + 1, end_coor[1] + 1 do
          for j = start_coor[2] + 1, end_coor[2] + 1 do
            grid[i][j] = functions.on(grid[i][j])
          end
        end
      else
        for i = start_coor[1] + 1, end_coor[1] + 1 do
          for j = start_coor[2] + 1, end_coor[2] + 1 do
            grid[i][j] = functions.off(grid[i][j])
          end
        end
      end
    else
      local start_coor = split[2]:split ","
      local end_coor = split[4]:split ","
      for i = start_coor[1] + 1, end_coor[1] + 1 do
        for j = start_coor[2] + 1, end_coor[2] + 1 do
          grid[i][j] = functions.toggle(grid[i][j])
        end
      end
    end
  end

  local lights = 0

  for i = 1, 1000 do
    for j = 1, 1000 do
      lights = lights + grid[i][j]
    end
  end

  return lights
end

function M:solve1()
  self.solution:add(
    "1",
    self:solver {
      on = function()
        return 1
      end,
      off = function()
        return 0
      end,
      toggle = function(val)
        return math.abs(val - 1)
      end,
    }
  )
end

function M:solve2()
  self.solution:add(
    "2",
    self:solver {
      on = function(val)
        return val + 1
      end,
      off = function(val)
        return math.max(val - 1, 0)
      end,
      toggle = function(val)
        return val + 2
      end,
    }
  )
end

M:run()

return M
