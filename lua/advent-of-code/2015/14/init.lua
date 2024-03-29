local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "14")

function M:parse(file)
  for line in file:lines() do
    local ints = line:only_ints()
    table.insert(self.input, {
      speed = ints[1],
      duration = ints[2],
      rest = ints[3],
      distance = 0,
      flying = ints[2],
      resting = 0,
      points = 0,
    })
  end
end

function M:solver(field)
  local deers = table.deepcopy(self.input)
  for _ = 1, self.test and 1000 or 2503 do
    for _, deer in ipairs(deers) do
      if deer.flying > 0 then
        deer.flying = deer.flying - 1
        deer.distance = deer.distance + deer.speed

        if deer.flying == 0 then
          deer.resting = deer.rest
        end
      elseif deer.resting > 0 then
        deer.resting = deer.resting - 1

        if deer.resting == 0 then
          deer.flying = deer.duration
        end
      end
    end

    local max = table.reduce(deers, -math.huge, function(carry, deer)
      return math.max(carry, deer.distance)
    end)

    for _, deer in ipairs(deers) do
      if deer.distance == max then
        deer.points = deer.points + 1
      end
    end
  end

  return table.reduce(deers, -math.huge, function(carry, deer)
    return math.max(carry, deer[field])
  end)
end

function M:solve1()
  self.solution:add("1", self:solver "distance")
end

function M:solve2()
  self.solution:add("2", self:solver "points")
end

M:run()

return M
