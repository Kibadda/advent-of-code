local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "06")

local function init()
  local grid = {}
  for i = 1, 1000 do
    table.insert(grid, {})
    for _ = 1, 1000 do
      table.insert(grid[i], 0)
    end
  end

  return grid
end

function M:solve1()
  local grid = init()

  for _, line in ipairs(self.input) do
    local split = line:split()
    if split[1] == "turn" then
      local start_coor = split[3]:split ","
      local end_coor = split[5]:split ","
      if split[2] == "on" then
        for i = start_coor[1] + 1, end_coor[1] + 1 do
          for j = start_coor[2] + 1, end_coor[2] + 1 do
            grid[i][j] = 1
          end
        end
      else
        for i = start_coor[1] + 1, end_coor[1] + 1 do
          for j = start_coor[2] + 1, end_coor[2] + 1 do
            grid[i][j] = 0
          end
        end
      end
    else
      local start_coor = split[2]:split ","
      local end_coor = split[4]:split ","
      for i = start_coor[1] + 1, end_coor[1] + 1 do
        for j = start_coor[2] + 1, end_coor[2] + 1 do
          grid[i][j] = math.abs(grid[i][j] - 1)
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

  self.solution:add("1", lights)
end

function M:solve2()
  local grid = init()

  for _, line in ipairs(self.input) do
    local split = line:split()
    if split[1] == "turn" then
      local start_coor = split[3]:split ","
      local end_coor = split[5]:split ","
      if split[2] == "on" then
        for i = start_coor[1] + 1, end_coor[1] + 1 do
          for j = start_coor[2] + 1, end_coor[2] + 1 do
            grid[i][j] = grid[i][j] + 1
          end
        end
      else
        for i = start_coor[1] + 1, end_coor[1] + 1 do
          for j = start_coor[2] + 1, end_coor[2] + 1 do
            grid[i][j] = grid[i][j] - 1
            if grid[i][j] < 0 then
              grid[i][j] = 0
            end
          end
        end
      end
    else
      local start_coor = split[2]:split ","
      local end_coor = split[4]:split ","
      for i = start_coor[1] + 1, end_coor[1] + 1 do
        for j = start_coor[2] + 1, end_coor[2] + 1 do
          grid[i][j] = grid[i][j] + 2
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

  self.solution:add("2", lights)
end

M:run()

return M
