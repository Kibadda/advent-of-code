--- @class AOCDay201806: AOCDay
--- @field input { max_x: integer, max_y: integer, points: Vector[] }
local M = require("advent-of-code.AOCDay"):new("2018", "06")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    max_x = -math.huge,
    max_y = -math.huge,
    points = {},
  }

  for _, line in ipairs(lines) do
    local ints = line:only_ints()
    self.input.max_x = math.max(self.input.max_x, ints[1])
    self.input.max_y = math.max(self.input.max_y, ints[2])

    table.insert(self.input.points, V(ints[1], ints[2]))
  end
end

function M:solve1()
  local function calculate(buffer)
    local points = {}

    for i = -buffer, self.input.max_x + buffer do
      for j = -buffer, self.input.max_y + buffer do
        local current = V(i, j)

        local nearest = {}
        local distance

        for k, point in ipairs(self.input.points) do
          local d = point:distance(current)

          if d == distance then
            table.insert(nearest, k)
          elseif not distance or d < distance then
            nearest = { k }
            distance = d
          end
        end

        if #nearest == 1 then
          points[nearest[1]] = (points[nearest[1]] or 0) + 1
        end
      end
    end

    return points
  end

  local a = calculate(0)
  local b = calculate(1)

  local max = -math.huge

  for i = 1, #a do
    if a[i] == b[i] then
      max = math.max(max, a[i])
    end
  end

  return max
end

function M:solve2()
  local area = 0

  for i = 1, self.input.max_x do
    for j = 1, self.input.max_y do
      local current = V(i, j)

      if
        table.reduce(self.input.points, 0, function(sum, point)
          return sum + point:distance(current)
        end) < (self.test and 32 or 10000)
      then
        area = area + 1
      end
    end
  end

  return area
end

M:run()
