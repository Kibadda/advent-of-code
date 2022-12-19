local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "19")

function M:parse_input(file)
  for line in file:lines() do
    local split = line:split()
    table.insert(self.input, {
      plans = {
        ore = {
          ore = tonumber(split[7]),
        },
        clay = {
          ore = tonumber(split[13]),
        },
        obsidian = {
          ore = tonumber(split[19]),
          clay = tonumber(split[22]),
        },
        geode = {
          ore = tonumber(split[28]),
          obsidian = tonumber(split[31]),
        },
      },
      max = {
        ore = math.max(
          tonumber(split[7]) or 0,
          tonumber(split[13]) or 0,
          tonumber(split[19]) or 0,
          tonumber(split[28]) or 0
        ),
        clay = tonumber(split[22]),
        obsidian = tonumber(split[31]),
        geode = math.huge,
      },
    })
  end
end

---@class State
---@field next (fun(self: State): table)
---@field new (fun(self: State, time: number, blueprint: table): State)
---@field robots table
---@field resources table
---@field blueprint table
---@field time number
local State = {
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

---@param state State
local function dfs(state)
  local queue = { state }

  local max = 0

  while #queue > 0 do
    ---@type State
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
    table.reduce(self.input, function(val, blueprint, i)
      return val + i * dfs(State:new(24, blueprint))
    end, 0)
  )
end

function M:solve2()
  self.solution:add(
    "2",
    table.reduce(self.input, function(val, blueprint, i)
      return i > 3 and val or val * dfs(State:new(32, blueprint))
    end, 1)
  )
end

M:run(false)

return M
