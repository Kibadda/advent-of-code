local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "06")

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
  self.solution:add("1", self:solver(4))
end

function M:solve2()
  self.solution:add("2", self:solver(14))
end

M:run()

return M
