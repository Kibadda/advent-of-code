--- @class AOCDay201601: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2016", "01")

--- @param lines string[]
function M:parse(lines)
  self.input = lines[1]:gsub(",", ""):gsub("L", "L "):gsub("R", "R "):split()
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
  return self
    :solver(function(n, current, dir)
      return current + dir * tonumber(n)
    end)
    :distance()
end

function M:solve2()
  local seen = {}
  return self
    :solver(function(n, current, dir)
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
    :distance()
end

M:run()
