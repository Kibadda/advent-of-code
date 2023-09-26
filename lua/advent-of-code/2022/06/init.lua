local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "06")

function M:solve1()
  local buffer = {}
  local index = 0
  for c in self.input[1]:gmatch "." do
    if #buffer >= 4 then
      table.remove(buffer, 1)
    end
    table.insert(buffer, c)

    index = index + 1

    if index > 3 and table.count_uniques(buffer) == 4 then
      break
    end
  end

  self.solution:add("1", index)
end

function M:solve2()
  local buffer = {}
  local index = 0
  for c in self.input[1]:gmatch "." do
    if #buffer >= 14 then
      table.remove(buffer, 1)
    end
    table.insert(buffer, c)

    index = index + 1

    if index > 13 and table.count_uniques(buffer) == 14 then
      break
    end
  end

  self.solution:add("2", index)
end

M:run()

return M
