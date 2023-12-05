local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2023", "01")

function M:solver(func)
  return table.reduce(self.input, 0, function(sum, value)
    local numbers = func(value)
    return sum + 10 * numbers[1] + numbers[#numbers]
  end)
end

function M:solve1()
  self.solution:add(
    "1",
    self:solver(function(value)
      return value:only_ints "%d"
    end)
  )
end

function M:solve2()
  self.solution:add(
    "2",
    self:solver(function(value)
      local numbers = {}
      for i = 1, #value do
        if tonumber(value:at(i)) then
          numbers[#numbers + 1] = tonumber(value:at(i))
        else
          for k, v in ipairs { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" } do
            if value:sub(i):startswith(v) then
              numbers[#numbers + 1] = k
            end
          end
        end
      end
      return numbers
    end)
  )
end

M:run()

return M
