--- @class AOCDay201724: AOCDay
--- @field input integer[][]
local M = require("advent-of-code.AOCDay"):new("2017", "24")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:only_ints())
  end
end

function M:solver(fun)
  local queue = {
    {
      bridge = {},
      available = table.deepcopy(self.input),
      pin = 0,
    },
  }

  while #queue > 0 do
    local current = table.remove(queue)

    local stop = true
    for i, comp in ipairs(current.available) do
      if comp[1] == current.pin then
        local s = table.deepcopy(current)
        table.remove(s.available, i)
        s.bridge[#s.bridge + 1] = comp
        s.pin = comp[2]
        queue[#queue + 1] = s
        stop = false
      end
      if comp[2] == current.pin then
        local s = table.deepcopy(current)
        table.remove(s.available, i)
        s.bridge[#s.bridge + 1] = comp
        s.pin = comp[1]
        queue[#queue + 1] = s
        stop = false
      end
    end

    if stop then
      fun(current)
    end
  end
end

local function count(s)
  local sum = 0
  for _, comp in ipairs(s.bridge) do
    sum = sum + comp[1] + comp[2]
  end
  return sum
end

function M:solve1()
  local max = -math.huge
  self:solver(function(s)
    max = math.max(max, count(s))
  end)
  return max
end

function M:solve2()
  local max = -math.huge
  local length = -math.huge
  self:solver(function(s)
    if length < #s.bridge then
      max = count(s)
      length = #s.bridge
    elseif length == #s.bridge then
      max = math.max(max, count(s))
    end
  end)
  return max
end

M:run()
