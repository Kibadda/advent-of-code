--- @class AOCDay201703: AOCDay
--- @field input integer
local M = require("advent-of-code.AOCDay"):new("2017", "03")

--- @param lines string[]
function M:parse(lines)
  self.input = assert(tonumber(lines[1]))
end

--- @param n integer
function M:solver(n)
  local x, y = 0, 0
  local direction = 0
  local step_size = 1
  local step_count = 0

  for _ = 2, n do
    if direction == 0 then
      x = x + 1
    elseif direction == 1 then
      y = y + 1
    elseif direction == 2 then
      x = x - 1
    elseif direction == 3 then
      y = y - 1
    end

    step_count = step_count + 1
    if step_count == step_size then
      direction = (direction + 1) % 4
      if direction == 0 or direction == 2 then
        step_size = step_size + 1
      end
      step_count = 0
    end
  end

  return V(x, y)
end

function M:solve1()
  return self:solver(self.input):distance()
end

function M:solve2()
  local grid = setmetatable({}, {
    __index = function(t, key)
      t[key] = {}
      return t[key]
    end,
  })

  local i = 1
  while true do
    local current = self:solver(i)

    local adjacents = current:adjacent(8)

    local sum = table.reduce(adjacents, 0, function(sum, pos)
      if grid[pos.x][pos.y] then
        return sum + grid[pos.x][pos.y]
      end

      return sum
    end)

    if sum == 0 then
      sum = 1
    end

    if sum > self.input then
      return sum
    end

    grid[current.x][current.y] = sum

    i = i + 1
  end
end

M:run()
