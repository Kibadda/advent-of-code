--- @class AOCDay201817: AOCDay
--- @field input { grid: table<integer, table<integer, "~"|"|"|"."|"#">>, spring: Vector, min: { x: integer, y: integer }, max: { x: integer, y: integer } }
local M = require("advent-of-code.AOCDay"):new("2018", "17")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    grid = {},
    min = { x = math.huge, y = math.huge },
    max = { x = -math.huge, y = -math.huge },
  }

  local grid = {}

  for _, line in ipairs(lines) do
    local x_s, x_e = line:match "y=(%d+)%.?%.?(%d*)"
    local y_s, y_e = line:match "x=(%d+)%.?%.?(%d*)"

    x_s = tonumber(x_s)
    x_e = tonumber(x_e) or x_s
    y_s = tonumber(y_s)
    y_e = tonumber(y_e) or y_s

    self.input.min.x, self.input.max.x = math.min(self.input.min.x, x_s), math.max(self.input.max.x, x_e)
    self.input.min.y, self.input.max.y = math.min(self.input.min.y, y_s), math.max(self.input.max.y, y_e)

    for i = x_s, x_e do
      grid[i] = grid[i] or {}
      for j = y_s, y_e do
        grid[i][j] = true
      end
    end
  end

  for i = 1, self.input.max.x - self.input.min.x + 1 do
    self.input.grid[i] = {}

    for j = 1, self.input.max.y - self.input.min.y + 3 do
      if grid[i + self.input.min.x - 1] and grid[i + self.input.min.x - 1][j - 1 + self.input.min.y - 1] then
        self.input.grid[i][j] = "#"
      else
        self.input.grid[i][j] = "."
      end
    end
  end

  for _ = 2, self.input.min.x do
    local row = {}
    for _ = 1, self.input.max.y - self.input.min.y + 3 do
      table.insert(row, ".")
    end
    table.insert(self.input.grid, 1, row)
  end

  self.input.spring = V(1, 500 - self.input.min.y + 2)

  local spring_row = {}
  for i = 1, self.input.max.y - self.input.min.y + 3 do
    table.insert(spring_row, i == self.input.spring.y and "+" or ".")
  end
  table.insert(self.input.grid, 1, spring_row)
end

function M:fill(i, j, dir)
  if self.input.grid[i][j] == "|" then
    self:fill(i, j + dir, dir)
    self.input.grid[i][j] = "~"
  end
end

function M:flow(i, j, dir)
  local e = self.input.grid[i] and self.input.grid[i][j] or "x"

  if e ~= "." then
    return e ~= "#" and e ~= "~"
  end

  self.input.grid[i][j] = "|"

  local leaky = self:flow(i + 1, j, 0)

  if leaky then
    return true
  end

  local lleaky = dir <= 0 and self:flow(i, j - 1, -1)
  local rleaky = dir >= 0 and self:flow(i, j + 1, 1)

  if lleaky or rleaky then
    return true
  end

  if dir == 0 then
    self:fill(i, j, -1)
    self:fill(i, j + 1, 1)
  end

  return false
end

function M:solver(with_flow)
  return table.reduce(self.input.grid, 0, function(seen, row, i)
    if i < self.input.min.x + 1 then
      return 0
    end

    return table.reduce(row, seen, function(seen_row, c)
      return seen_row + ((c == "~" or (with_flow and c == "|")) and 1 or 0)
    end)
  end)
end

function M:solve1()
  self:flow(self.input.spring.x + 1, self.input.spring.y)

  return self:solver(true)
end

function M:solve2()
  return self:solver(false)
end

M:run()
