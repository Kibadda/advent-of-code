--- @class AOCDay201903: AOCDay
--- @field input string[][]
local M = require("advent-of-code.AOCDay"):new("2019", "03")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:split ",")
  end
end

function M:solver(func)
  local path = {}

  local pos = V(0, 0)
  local steps = 0
  for _, p in ipairs(self.input[1]) do
    local d = match(p:at(1)) {
      R = V(0, 1),
      L = V(0, -1),
      D = V(1, 0),
      U = V(-1, 0),
    }

    for _ = 1, p:only_ints()[1] do
      steps = steps + 1
      pos = pos + d
      path[pos:string()] = math.min(path[pos:string()] or math.huge, steps)
    end
  end

  --- @type Vector[]
  local intersections = {}
  local path2 = {}
  pos = V(0, 0)
  steps = 0
  for _, p in ipairs(self.input[2]) do
    local d = match(p:at(1)) {
      R = V(0, 1),
      L = V(0, -1),
      D = V(1, 0),
      U = V(-1, 0),
    }

    for _ = 1, p:only_ints()[1] do
      pos = pos + d
      steps = steps + 1
      path2[pos:string()] = math.min(path2[pos:string()] or math.huge, steps)

      if path[pos:string()] then
        table.insert(intersections, pos)
      end
    end
  end

  return func(intersections, path, path2)
end

function M:solve1()
  return self:solver(function(intersections)
    return table.reduce(intersections, math.huge, function(manhattan, p)
      return math.min(manhattan, p:distance())
    end)
  end)
end

function M:solve2()
  return self:solver(function(intersections, path1, path2)
    return table.reduce(intersections, math.huge, function(steps, p)
      return math.min(steps, path1[p:string()] + path2[p:string()])
    end)
  end)
end

M:run()
