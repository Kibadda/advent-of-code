local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "19")

function M:parse_input(file)
  for line in file:lines() do
    local split = line:only_ints()
    table.insert(self.input, {
      plans = {
        ore = {
          ore = tonumber(split[2]),
        },
        clay = {
          ore = tonumber(split[3]),
        },
        obsidian = {
          ore = tonumber(split[4]),
          clay = tonumber(split[5]),
        },
        geode = {
          ore = tonumber(split[6]),
          obsidian = tonumber(split[7]),
        },
      },
      max = {
        ore = math.max(
          tonumber(split[2]) or 0,
          tonumber(split[3]) or 0,
          tonumber(split[4]) or 0,
          tonumber(split[6]) or 0
        ),
        clay = tonumber(split[5]),
        obsidian = tonumber(split[7]),
        geode = math.huge,
      },
    })
  end
end

---@class GeodeState
---@field next (fun(self: GeodeState): table)
---@field new (fun(self: GeodeState, time: number, blueprint: table): GeodeState)
---@field robots table
---@field resources table
---@field blueprint table
---@field time number
local GeodeState = {
  next = function(self)
    local next_states = {}

    for _, r in ipairs { "ore", "clay", "obsidian", "geode" } do
      if self.robots[r] < self.blueprint.max[r] then
        local steps = -math.huge
        for resource, amount in pairs(self.blueprint.plans[r]) do
          if amount - self.resources[resource] < 0 then
            steps = math.max(steps, 0)
          else
            steps = math.max(steps, math.ceil((amount - self.resources[resource]) / self.robots[resource]))
          end
        end

        if steps <= self.time then
          local next = table.deepcopy(self)

          next.time = next.time - (steps + 1)

          for robot, amount in pairs(next.robots) do
            next.resources[robot] = next.resources[robot] + (steps + 1) * amount
          end

          for resource, amount in pairs(next.blueprint.plans[r]) do
            next.resources[resource] = next.resources[resource] - amount
          end
          next.robots[r] = next.robots[r] + 1

          table.insert(next_states, next)
        end
      end
    end

    return next_states
  end,
  new = function(self, time, blueprint)
    return setmetatable({
      resources = {
        ore = 0,
        clay = 0,
        obsidian = 0,
        geode = 0,
      },
      robots = {
        ore = 1,
        clay = 0,
        obsidian = 0,
        geode = 0,
      },
      time = time,
      blueprint = blueprint,
    }, {
      __index = self,
    })
  end,
}

---@param state GeodeState
function M:solver(state)
  local queue = { state }

  local max = 0

  while #queue > 0 do
    ---@type GeodeState
    local current = table.remove(queue, #queue)
    local next_states = current:next()
    if #next_states == 0 then
      for robot, amount in pairs(current.robots) do
        current.resources[robot] = current.resources[robot] + current.time * amount
      end
      max = math.max(max, current.resources.geode)
    else
      for _, s in ipairs(next_states) do
        if s.resources.geode + s.time * s.robots.geode + (s.time * (s.time + 1)) / 2 > max then
          table.insert(queue, s)
        end
      end
    end
  end

  return max
end

function M:solve1()
  self.solution:add(
    "1",
    table.reduce(self.input, 0, function(val, blueprint, i)
      return val + i * self:solver(GeodeState:new(24, blueprint))
    end)
  )
end

function M:solve2()
  self.solution:add(
    "2",
    table.reduce(self.input, 1, function(val, blueprint, i)
      return i > 3 and val or val * self:solver(GeodeState:new(32, blueprint))
    end)
  )
end

M:run()

return M
