local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "01")

function M:parse_input(file)
  for line in file:lines() do
    self.input = line:gsub(",", ""):gsub("L", "L "):gsub("R", "R "):split()
  end
end

function M:solve1()
  local current = V(0, 0)
  local dir = V(-1, 0)
  for _, i in ipairs(self.input) do
    match(i) {
      [{ "L", "R" }] = function(d)
        dir = dir * d
      end,
      _ = function(n)
        current = current + dir * tonumber(n)
      end,
    }
  end
  self.solution:add("1", math.abs(current.x) + math.abs(current.y))
end

function M:solve2()
  local seen = {}
  local current = V(0, 0)
  local dir = V(-1, 0)
  for _, i in ipairs(self.input) do
    local value = match(i) {
      [{ "L", "R" }] = function(d)
        dir = dir * d
      end,
      _ = function(n)
        for _ = 1, n do
          current = current + dir
          local s = ("%d|%d"):format(current.x, current.y)
          if seen[s] then
            return math.abs(current.x) + math.abs(current.y)
          end
          seen[s] = true
        end
      end,
    }

    if value then
      self.solution:add("2", value)
      break
    end
  end
end

M:run()

return M
