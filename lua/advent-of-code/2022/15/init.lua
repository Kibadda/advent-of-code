local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "15")

local min_x = math.huge
local max_x = 0

function M:parse_input(file)
  self.input = {
    S = {},
    B = {},
  }
  for line in file:lines() do
    local split = line:gsub(",", ""):split ":"
    local sensor = {
      x = tonumber(split[1]:split()[3]:split("=")[2]),
      y = tonumber(split[1]:split()[4]:split("=")[2]),
    }
    local beacon = {
      x = tonumber(split[2]:split()[5]:split("=")[2]),
      y = tonumber(split[2]:split()[6]:split("=")[2]),
    }

    sensor.manhattan = math.abs(sensor.x - beacon.x) + math.abs(sensor.y - beacon.y)

    max_x = math.max(max_x, sensor.x + sensor.manhattan, beacon.x)
    min_x = math.min(min_x, sensor.x - sensor.manhattan, beacon.x)

    table.insert(self.input.S, sensor)
    table.insert(self.input.B, beacon)
  end
end

function M:solve1()
  local y = self.test and 10 or 2000000
  local count = 0
  for x = min_x, max_x do
    if table.find(self.input.B, { x = x, y = y }) == nil then
      for _, sensor in ipairs(self.input.S) do
        if math.abs(sensor.x - x) + math.abs(sensor.y - y) <= sensor.manhattan then
          count = count + 1
          break
        end
      end
    end
  end

  self.solution:add("1", count)
end

function M:solve2()
  local bound = self.test and 20 or 4000000
  local found = false
  for _, sensor in ipairs(self.input.S) do
    local points = {}
    for i = 0, sensor.manhattan + 1 do
      local j = sensor.manhattan + 1 - i

      if sensor.x + i <= bound then
        if sensor.y + j <= bound then
          table.insert(points, { x = sensor.x + i, y = sensor.y + j })
        end
        if sensor.y - j >= 0 then
          table.insert(points, { x = sensor.x + i, y = sensor.y - j })
        end
      end
      if sensor.x - i >= 0 then
        if sensor.y + j <= bound then
          table.insert(points, { x = sensor.x - i, y = sensor.y + j })
        end
        if sensor.y - j >= 0 then
          table.insert(points, { x = sensor.x - i, y = sensor.y - j })
        end
      end
    end

    for _, point in ipairs(points) do
      local in_range = false
      for _, otherSensor in ipairs(self.input.S) do
        if otherSensor.x ~= sensor.x or otherSensor.y ~= sensor.y then
          if math.abs(point.x - otherSensor.x) + math.abs(point.y - otherSensor.y) <= otherSensor.manhattan then
            in_range = true
            break
          end
        end
      end
      if not in_range then
        self.solution:add("2", point.x * 4000000 + point.y)
        break
      end
    end
    if found then
      break
    end
  end
end

M:run()

return M
