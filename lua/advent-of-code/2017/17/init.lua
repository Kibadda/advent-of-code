--- @class AOCDay201717: AOCDay
--- @field input number
local M = require("advent-of-code.AOCDay"):new("2017", "17")

--- @param lines string[]
function M:parse(lines)
  self.input = assert(tonumber(lines[1]))
end

function M:solve1()
  local buffer = { 0 }
  local position = 1

  for i = 1, 2017 do
    position = ((position + self.input) % #buffer) + 1
    table.insert(buffer, position + 1, i)
  end

  return buffer[position + 2]
end

function M:solve2()
  local solution = 0
  local length = 1
  local position = 1
  for i = 1, 50000000 do
    position = ((position + self.input) % length) + 1
    length = length + 1
    if position == 1 then
      solution = i
    end
  end

  return solution
end

M:run()
