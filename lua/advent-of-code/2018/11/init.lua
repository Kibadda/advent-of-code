--- @class AOCDay201811: AOCDay
--- @field input integer[][]
local M = require("advent-of-code.AOCDay"):new("2018", "11")

--- @param lines string[]
function M:parse(lines)
  local serial = tonumber(lines[1])

  for i = 1, 300 do
    self.input[i] = {}

    for j = 1, 300 do
      self.input[i][j] = (math.floor(((((i + 10) * j) + serial) * (i + 10)) / 100) % 10) - 5
    end
  end
end

function M:solver(size)
  local max = -math.huge
  local x, y = 0, 0
  for i = 1, 300 - size do
    for j = 1, 300 - size do
      local power = 0

      for ii = 0, size - 1 do
        for jj = 0, size - 1 do
          power = power + self.input[i + ii][j + jj]
        end
      end

      if power > max then
        max = power
        x, y = i, j
      end
    end
  end

  return { solution = ("%s,%s,%s"):format(x, y, size), value = max }
end

function M:solve1()
  return self:solver(3).solution
end

function M:solve2()
  return table.reduce(table.range(300), { value = -math.huge, solution = "" }, function(max, size)
    local power = self:solver(size)

    if power.value > max.value then
      return power
    end

    return max
  end).solution
end

M:run()
