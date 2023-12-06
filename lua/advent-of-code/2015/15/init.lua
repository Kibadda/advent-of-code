local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "15")

function M:parse(file)
  for line in file:lines() do
    local ints = line:only_ints "-?%d+"
    table.insert(self.input, {
      capacity = ints[1],
      durability = ints[2],
      flavor = ints[3],
      texture = ints[4],
      calories = ints[5],
    })
  end
end

local function score(check_calories, input, ...)
  local numbers = { ... }
  local types = { "capacity", "durability", "flavor", "texture" }
  if check_calories then
    table.insert(types, 1, "calories")
  end
  return table.reduce(
    table.map(types, function(type)
      return table.reduce(numbers, 0, function(carry, number, index)
        return carry + number * input[index][type]
      end)
    end),
    1,
    function(carry, number, k)
      if check_calories then
        if k == 1 then
          if number == 500 then
            return 1
          else
            return 0
          end
        else
          return (number < 0 and 0 or number) * carry
        end
      else
        return (number < 0 and 0 or number) * carry
      end
    end
  )
end

function M:solver(check_calories)
  local max = -math.huge
  if #self.input == 2 then
    for i = 0, 100 do
      for j = 0, 100 do
        if i + j == 100 then
          max = math.max(max, score(check_calories, self.input, i, j))
        end
      end
    end
  else
    for i = 0, 100 do
      for j = 0, 100 do
        for k = 0, 100 do
          for l = 0, 100 do
            if i + j + k + l == 100 then
              max = math.max(max, score(check_calories, self.input, i, j, k, l))
            end
          end
        end
      end
    end
  end

  return max
end

function M:solve1()
  self.solution:add("1", self:solver(false))
end

function M:solve2()
  self.solution:add("2", self:solver(true))
end

M:run()

return M
