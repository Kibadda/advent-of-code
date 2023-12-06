local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "20")

function M:parse(file)
  for line in file:lines() do
    self.input.gifts = tonumber(line)
  end
end

function M:solver(stops, amount)
  local function calculate_gifts(house)
    local gifts = 0
    for i = 1, math.sqrt(house) do
      if house % i == 0 then
        if i * stops >= house then
          gifts = gifts + amount * i
        end
        if house / i ~= i and (house / i) * stops >= house then
          gifts = gifts + (house / i) * amount
        end
      end
    end
    return gifts
  end

  local house = 0
  repeat
    house = house + 1
  until calculate_gifts(house) >= self.input.gifts

  return house
end

function M:solve1()
  self.solution:add("1", self:solver(math.huge, 10))
end

function M:solve2()
  self.solution:add("2", self:solver(50, 11))
end

M:run()

return M
