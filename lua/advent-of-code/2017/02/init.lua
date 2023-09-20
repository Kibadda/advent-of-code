local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "02")

function M:solve1()
  local sum = 0
  for _, line in ipairs(self.input) do
    local max = -math.huge
    local min = math.huge
    for _, number in ipairs(line:only_ints()) do
      max = math.max(max, number)
      min = math.min(min, number)
    end

    sum = sum + (max - min)
  end
  self.solution:add("1", sum)
end

function M:solve2()
  local sum = 0
  for _, line in ipairs(self.input) do
    local ints = line:only_ints()

    for i, num1 in ipairs(ints) do
      local done = false
      for j, num2 in ipairs(ints) do
        if i ~= j then
          if num1 % num2 == 0 then
            sum = sum + (num1 / num2)
            done = true
            break
          end
        end
      end
      if done then
        break
      end
    end
  end
  self.solution:add("2", sum)
end

M:run(false)

return M
