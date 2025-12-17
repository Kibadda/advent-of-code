--- @class AOCDay201510: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2015", "10")

function M:solver(iterations)
  local str = self.input[1]
  for _ = 1, iterations do
    local num = nil
    local count = 0
    local next_str = ""
    for c in str:gmatch "." do
      if c ~= num and count > 0 then
        next_str = next_str .. count .. num
        count = 0
      end

      num = c
      count = count + 1
    end
    str = next_str .. count .. num
  end

  return #str
end

function M:solve1()
  return self:solver(40)
end

function M:solve2()
  return self:solver(50)
end

M:run()
