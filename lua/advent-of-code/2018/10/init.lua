--- @class AOCDay201810: AOCDay
--- @field input { position: Vector, velocity: Vector }[]
local M = require("advent-of-code.AOCDay"):new("2018", "10")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local ints = line:only_ints "%-?%d+"
    table.insert(self.input, {
      position = V(ints[1], ints[2]),
      velocity = V(ints[3], ints[4]),
    })
  end
end

function M:solve1() end

function M:solve2()
  local seconds = 0

  while true do
    local min_x, max_x = math.huge, -math.huge
    local min_y, max_y = math.huge, -math.huge
    for _, light in ipairs(self.input) do
      light.position = light.position + light.velocity
      min_x, max_x = math.min(min_x, light.position.x), math.max(max_x, light.position.x)
      min_y, max_y = math.min(min_y, light.position.y), math.max(max_y, light.position.y)
    end

    seconds = seconds + 1

    if math.abs(min_x - max_x) * math.abs(min_y - max_y) < #self.input * 10 then
      local grid = {}

      for _, light in ipairs(self.input) do
        grid[light.position.x] = grid[light.position.x] or {}
        grid[light.position.x][light.position.y] = "#"
      end

      for i = min_x, max_x do
        local s = ""
        for j = min_y, max_y do
          if grid[i] and grid[i][j] then
            s = s .. "#"
          else
            s = s .. " "
          end
        end
        print(s)
      end

      print "<Enter> to continue. <C-d> to stop."

      local s = io.read()

      if s ~= "" then
        break
      end
    end
  end

  return seconds
end

M:run()
