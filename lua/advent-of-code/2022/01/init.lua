local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "01")

function M:parse_input(file)
  table.insert(self.input, 0)

  local current_pos = 1
  for line in file:lines() do
    local number = tonumber(line)
    if number == nil then
      table.insert(self.input, 0)
      current_pos = current_pos + 1
    else
      self.input[current_pos] = self.input[current_pos] + number
    end
  end
end

function M:solve1()
  table.sort(self.input, function(a, b)
    return b < a
  end)
  self.solution:add("one", self.input[1])
end

function M:solve2()
  table.sort(self.input, function(a, b)
    return b < a
  end)
  self.solution:add("two", self.input[1] + self.input[2] + self.input[3])
end

M:run(false)

return M
