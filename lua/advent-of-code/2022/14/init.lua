local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "14")

local min, max = math.huge, 0

function M:parse_input(file)
  for line in file:lines() do
    local split = line:split()
    for i = 3, #split, 2 do
      local start_split = split[i - 2]:split ","
      local end_split = split[i]:split ","
      local start_coor = {
        x = tonumber(start_split[1]),
        y = tonumber(start_split[2]) + 1,
      }
      local end_coor = {
        x = tonumber(end_split[1]),
        y = tonumber(end_split[2]) + 1,
      }
      min = math.min(min, start_coor.x, end_coor.x)
      max = math.max(max, start_coor.x, end_coor.x)

      if start_coor.x == end_coor.x then
        for j = math.min(start_coor.y, end_coor.y), math.max(start_coor.y, end_coor.y) do
          if self.input[j] == nil then
            self.input[j] = {}
          end

          self.input[j][start_coor.x] = "#"
        end
      else
        for j = math.min(start_coor.x, end_coor.x), math.max(start_coor.x, end_coor.x) do
          if self.input[start_coor.y] == nil then
            self.input[start_coor.y] = {}
          end

          self.input[start_coor.y][j] = "#"
        end
      end
    end
  end
  for i = 1, #self.input do
    if self.input[i] == nil then
      self.input[i] = {}
    end
    for j = min, max do
      if self.input[i][j] == nil then
        self.input[i][j] = "."
      end
    end
  end
end

function M:solve1()
  local grid = table.deepcopy(self.input)
  local start = { x = 500, y = 1 }
  local steps_till_nirvana = 0

  local function get_rest_pos(pos)
    if pos == nil then
      return pos
    elseif grid[pos.y + 1] == nil then
      return nil
    elseif grid[pos.y + 1][pos.x] == nil then
      return nil
    elseif grid[pos.y + 1][pos.x] == "." then
      return get_rest_pos {
        x = pos.x,
        y = pos.y + 1,
      }
    elseif grid[pos.y + 1][pos.x - 1] == nil then
      return nil
    elseif grid[pos.y + 1][pos.x - 1] == "." then
      return get_rest_pos {
        x = pos.x - 1,
        y = pos.y + 1,
      }
    elseif grid[pos.y + 1][pos.x + 1] == nil then
      return nil
    elseif grid[pos.y + 1][pos.x + 1] == "." then
      return get_rest_pos {
        x = pos.x + 1,
        y = pos.y + 1,
      }
    else
      return pos
    end
  end

  local current = get_rest_pos(start)
  while current ~= nil do
    steps_till_nirvana = steps_till_nirvana + 1
    grid[current.y][current.x] = "o"
    current = get_rest_pos(start)
  end

  self.solution:add("1", steps_till_nirvana)
end

function M:solve2()
  local grid = table.deepcopy(self.input)
  local start = { x = 500, y = 1 }
  local steps_till_stop = 0

  grid[#grid + 1] = {}
  for j = min, max do
    grid[#grid][j] = "."
  end
  grid[#grid + 1] = {}
  for j = min, max do
    grid[#grid][j] = "#"
  end

  local function get_rest_pos(pos)
    if grid[pos.y + 1][pos.x] == "." then
      return get_rest_pos {
        x = pos.x,
        y = pos.y + 1,
      }
    end

    if grid[pos.y + 1][pos.x - 1] == nil then
      for i = 1, #grid do
        grid[i][pos.x - 1] = i == #grid and "#" or "."
      end
      min = min - 1
    end
    if grid[pos.y + 1][pos.x - 1] == "." then
      return get_rest_pos {
        x = pos.x - 1,
        y = pos.y + 1,
      }
    end

    if grid[pos.y + 1][pos.x + 1] == nil then
      for i = 1, #grid do
        grid[i][pos.x + 1] = i == #grid and "#" or "."
      end
      max = max + 1
    end
    if grid[pos.y + 1][pos.x + 1] == "." then
      return get_rest_pos {
        x = pos.x + 1,
        y = pos.y + 1,
      }
    end

    return pos
  end

  local current = get_rest_pos(start)
  while current.x ~= start.x or current.y ~= start.y do
    steps_till_stop = steps_till_stop + 1
    grid[current.y][current.x] = "o"
    current = get_rest_pos(start)
  end

  self.solution:add("2", steps_till_stop + 1)
end

M:run()

return M
