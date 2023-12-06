local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "24")

function M:parse(file)
  self.input = {
    pos = nil,
    points = {},
    grid = {},
  }
  local i = 0
  for line in file:lines() do
    i = i + 1
    self.input.grid[i] = self.input.grid[i] or {}
    for j, c in ipairs(line:to_list()) do
      self.input.grid[i][j] = c

      if tonumber(c) then
        if tonumber(c) > 0 then
          self.input.points[#self.input.points + 1] = { x = i, y = j, number = tonumber(c) }
        else
          self.input.pos = { x = i, y = j, number = 0 }
        end
      end
    end
  end
end

local function next(grid, pos)
  local p = {}
  if grid[pos.x - 1][pos.y] ~= "#" then
    table.insert(p, { x = pos.x - 1, y = pos.y })
  end
  if grid[pos.x + 1][pos.y] ~= "#" then
    table.insert(p, { x = pos.x + 1, y = pos.y })
  end
  if grid[pos.x][pos.y - 1] ~= "#" then
    table.insert(p, { x = pos.x, y = pos.y - 1 })
  end
  if grid[pos.x][pos.y + 1] ~= "#" then
    table.insert(p, { x = pos.x, y = pos.y + 1 })
  end
  return p
end

local function check(points, pos)
  for i, point in ipairs(points) do
    if point.x == pos.x and point.y == pos.y then
      return i
    end
  end
end

local function id(state)
  local str = state.pos.x .. "|" .. state.pos.y .. "|"
  for _, point in ipairs(state.points) do
    str = str .. "|" .. point.number
  end
  return str
end

function M:solver(returning)
  local queue = {
    {
      points = table.deepcopy(self.input.points),
      pos = table.deepcopy(self.input.pos),
      steps = 0,
      returning = false,
    },
  }

  local seen = {}

  while #queue > 0 do
    local current = table.remove(queue, 1)

    if #current.points == 0 then
      return current
    else
      local next_points = next(self.input.grid, current.pos)
      for _, pos in ipairs(next_points) do
        local new = table.deepcopy(current)
        new.pos = { x = pos.x, y = pos.y }
        new.steps = current.steps + 1
        if self.input.grid[pos.x][pos.y] ~= "." then
          local index = check(new.points, pos)
          if index then
            table.remove(new.points, index)

            if returning and not new.returning and #new.points == 0 then
              table.insert(new.points, table.deepcopy(self.input.pos))
              new.returning = true
            end
          end
        end
        if not seen[id(new)] then
          table.insert(queue, new)
          seen[id(new)] = true
        end
      end
    end
  end
end

function M:solve1()
  self.solution:add("1", self:solver(false).steps)
end

function M:solve2()
  self.solution:add("2", self:solver(true).steps)
end

M:run()

return M
