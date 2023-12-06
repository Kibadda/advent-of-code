local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "01")

function M:parse(file)
  for line in file:lines() do
    self.input = line:gsub(",", ""):gsub("L", "L "):gsub("R", "R "):split()
  end
end

function M:solver(fun)
  local current = V(0, 0)
  local dir = V(-1, 0)
  local stop = false
  for _, i in ipairs(self.input) do
    local value = match(i) {
      [{ "L", "R" }] = function()
        dir = dir * i
      end,
      _ = function()
        current, stop = fun(i, current, dir)

        if stop then
          return stop
        end
      end,
    }

    if value then
      return current
    end
  end
  return current
end

function M:solve1()
  ---@type Vector
  local result = self:solver(function(n, current, dir)
    return current + dir * tonumber(n)
  end)
  self.solution:add("1", result:distance())
end

function M:solve2()
  local seen = {}
  ---@type Vector
  local result = self:solver(function(n, current, dir)
    for _ = 1, tonumber(n) do
      current = current + dir
      local s = ("%d|%d"):format(current.x, current.y)
      if seen[s] then
        return current, true
      end
      seen[s] = true
    end
    return current, false
  end)
  self.solution:add("2", result:distance())
end

M:run()

return M
