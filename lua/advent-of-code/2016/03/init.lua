local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "03")

function M:parse(file)
  for line in file:lines() do
    table.insert(self.input, line:only_ints())
  end
end

function M:solver(input)
  local possible = 0
  for _, triangle in ipairs(input) do
    if
      triangle[1] + triangle[2] > triangle[3]
      and triangle[1] + triangle[3] > triangle[2]
      and triangle[2] + triangle[3] > triangle[1]
    then
      possible = possible + 1
    end
  end

  return possible
end

function M:solve1()
  self.solution:add("1", self:solver(self.input))
end

function M:solve2()
  local real_input = {}
  for i = 1, #self.input, 3 do
    table.insert(real_input, {
      self.input[i][1],
      self.input[i + 1][1],
      self.input[i + 2][1],
    })
    table.insert(real_input, {
      self.input[i][2],
      self.input[i + 1][2],
      self.input[i + 2][2],
    })
    table.insert(real_input, {
      self.input[i][3],
      self.input[i + 1][3],
      self.input[i + 2][3],
    })
  end

  self.solution:add("2", self:solver(real_input))
end

M:run()

return M
