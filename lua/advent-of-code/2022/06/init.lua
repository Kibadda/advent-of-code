--- @class AOCDay202206: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2022", "06")

function M:solver(limit)
  local buffer = {}
  local index = 0
  for c in self.input[1]:gmatch "." do
    if #buffer >= limit then
      table.remove(buffer, 1)
    end
    table.insert(buffer, c)

    index = index + 1

    if index >= limit and table.count_uniques(buffer) == limit then
      break
    end
  end
  return index
end

function M:solve1()
  return self:solver(4)
end

function M:solve2()
  return self:solver(14)
end

M:run()
