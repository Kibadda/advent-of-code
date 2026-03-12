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

--- low:  338
function M:solve1()
  --- @alias AOCDay201817Data { turned: "L"|"R"?, pos: Vector }

  --- @type AOCDay201817Data
  local current = { pos = self.input.spring + V(1, 0) }
  local is_backtracking = false

  local path = { current }

  local function p(grid)
    print()
    for i, row in ipairs(grid) do
      if i < 100 then
        local s = ""
        for j, c in ipairs(row) do
          if V(i, j) == current.pos then
            s = s .. "\27[31m" .. c .. "\27[0m"
          else
            s = s .. c
          end
        end
        print(s)
      end
    end
  end

  p(self.input.grid)

  local settled = false
  while #path > 0 do
    if is_backtracking then
      if settled then
      else
      end

      if not settled then
        current = table.remove(path)
      elseif self.input.grid[current.pos.x][current.pos.y - 1] == "|" then
        settled = false
        is_backtracking = false
        table.insert(path, current)
        current = { pos = current.pos + V(0, -1), turned = "L" }
      elseif self.input.grid[current.pos.x][current.pos.y + 1] == "|" then
        settled = false
        is_backtracking = false
        table.insert(path, current)
        current = { pos = current.pos + V(0, 1), turned = "R" }
      else
        self.input.grid[current.pos.x][current.pos.y] = "~"
        current = table.remove(path)
        settled = true
      end

      -- if self.input.grid[current.pos.x + 1][current.pos.y] == "|" then
      --   current = table.remove(path)
      -- elseif current.turned then
      --   if self.input.grid[current.pos.x][current.pos.y + (current.turned == "L" and -1 or 1)] == "~" then
      --     settled = true
      --     self.input.grid[current.pos.x][current.pos.y] = "~"
      --   else
      --     self.input.grid[current.pos.x][current.pos.y] = "|"
      --   end
      --
      --   current = table.remove(path)
      -- elseif self.input.grid[current.pos.x][current.pos.y - 1] == "." then
      --   self.input.grid[current.pos.x][current.pos.y] = "|"
      --   table.insert(path, current)
      --   current = { pos = current.pos + V(0, -1), turned = "L" }
      --   is_backtracking = false
      -- elseif self.input.grid[current.pos.x][current.pos.y + 1] == "." then
      --   self.input.grid[current.pos.x][current.pos.y] = "|"
      --   table.insert(path, current)
      --   current = { pos = current.pos + V(0, 1), turned = "R" }
      --   is_backtracking = false
      -- elseif
      --   self.input.grid[current.pos.x][current.pos.y - 1] == "|"
      --   or self.input.grid[current.pos.x][current.pos.y + 1] == "|"
      -- then
      --   current = table.remove(path)
      -- else
      --   self.input.grid[current.pos.x][current.pos.y] = "~"
      --   settled = true
      --   current = table.remove(path)
      -- end
    else
      if not self.input.grid[current.pos.x + 1] then
        is_backtracking = true
        self.input.grid[current.pos.x][current.pos.y] = "|"
        current = table.remove(path)
      elseif self.input.grid[current.pos.x + 1][current.pos.y] == "." then
        self.input.grid[current.pos.x][current.pos.y] = "|"
        table.insert(path, current)
        current = { pos = current.pos + V(1, 0) }
      elseif
        (not current.turned or current.turned == "L") and self.input.grid[current.pos.x][current.pos.y - 1] == "."
      then
        self.input.grid[current.pos.x][current.pos.y] = "|"
        table.insert(path, current)
        current = { pos = current.pos + V(0, -1), turned = "L" }
      elseif
        (not current.turned or current.turned == "R") and self.input.grid[current.pos.x][current.pos.y + 1] == "."
      then
        self.input.grid[current.pos.x][current.pos.y] = "|"
        table.insert(path, current)
        current = { pos = current.pos + V(0, 1), turned = "R" }
      else
        self.input.grid[current.pos.x][current.pos.y] = "~"
        settled = true
        current = table.remove(path)
        is_backtracking = true
      end
    end

    p(self.input.grid)

    if io.read() ~= "" then
      break
    end
  end

  return table.reduce(self.input.grid, 0, function(seen, row)
    return table.reduce(row, seen, function(seen_row, c)
      return seen_row + ((c == "~" or c == "|") and 1 or 0)
    end)
  end)
end

function M:solve2()
  --
end

M:run()
