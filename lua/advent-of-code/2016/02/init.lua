local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "02")

function M:solver(start, cases, coor_to_char)
  local current = start
  local pass = ""

  for _, line in ipairs(self.input) do
    for c in line:gmatch "." do
      match(c)(cases(current))
    end
    pass = pass .. coor_to_char(current)
  end

  return pass
end

function M:solve1()
  self.solution:add(
    "1",
    self:solver(V(0, 0), function(current)
      return {
        U = function()
          current.x = math.max(-1, current.x - 1)
        end,
        D = function()
          current.x = math.min(1, current.x + 1)
        end,
        R = function()
          current.y = math.min(1, current.y + 1)
        end,
        L = function()
          current.y = math.max(-1, current.y - 1)
        end,
      }
    end, function(current)
      return 3 * (current.x + 1) + (current.y + 2)
    end)
  )
end

function M:solve2()
  self.solution:add(
    "2",
    self:solver(V(0, -2), function(current)
      return {
        U = function()
          if current.x + (current.y < 0 and current.y or -current.y) > -2 then
            current.x = current.x - 1
          end
        end,
        D = function()
          if current.x + (current.y > 0 and current.y or -current.y) < 2 then
            current.x = current.x + 1
          end
        end,
        R = function()
          if current.y + (current.x > 0 and current.x or -current.x) < 2 then
            current.y = current.y + 1
          end
        end,
        L = function()
          if current.y + (current.x < 0 and current.x or -current.x) > -2 then
            current.y = current.y - 1
          end
        end,
      }
    end, function(current)
      return match(("%d|%d"):format(current.x, current.y)) {
        ["-2|0"] = 1,
        ["-1|-1"] = 2,
        ["-1|0"] = 3,
        ["-1|1"] = 4,
        ["0|-2"] = 5,
        ["0|-1"] = 6,
        ["0|0"] = 7,
        ["0|1"] = 8,
        ["0|2"] = 9,
        ["1|-1"] = "A",
        ["1|0"] = "B",
        ["1|1"] = "C",
        ["2|0"] = "D",
      }
    end)
  )
end

M:run()

return M
