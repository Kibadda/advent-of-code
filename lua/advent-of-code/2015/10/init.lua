local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "10")

function M:parse_input(file)
  for line in file:lines() do
    self.input.number = line
  end
end

function M:solver(iterations)
  local str = self.input.number
  for _ = 1, iterations do
    print(#str)
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
  self.solution:add("1", self:solver(40))
end

function M:solve2()
  self.solution:add("2", self:solver(50))
end

M:run(false)

return M
