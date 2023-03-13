local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "14")

function M:parse_input(file)
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

function M:solve1(time)
  local deers = table.deepcopy(self.input)
  for _ = 1, time do
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
  end
  self.solution:add(
    "1",
    table.reduce(deers, function(carry, deer)
      return math.max(carry, deer.distance)
    end, -math.huge)
  )
end

function M:solve2(time)
  local deers = table.deepcopy(self.input)
  for _ = 1, time do
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
    local max = table.reduce(deers, function(carry, deer)
      return math.max(carry, deer.distance)
    end, -math.huge)

    for _, deer in ipairs(deers) do
      if deer.distance == max then
        deer.points = deer.points + 1
      end
    end
  end
  self.solution:add(
    "2",
    table.reduce(deers, function(carry, deer)
      return math.max(carry, deer.points)
    end, -math.huge)
  )
end

M:run(false, { 1000, 2503 })

return M
