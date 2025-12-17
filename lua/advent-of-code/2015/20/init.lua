--- @class AOCDay201520: AOCDay
--- @field input number
local M = require("advent-of-code.AOCDay"):new("2015", "20")

--- @param lines string[]
function M:parse(lines)
  self.input = assert(tonumber(lines[1]))
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
  until calculate_gifts(house) >= self.input

  return house
end

function M:solve1()
  return self:solver(math.huge, 10)
end

function M:solve2()
  return self:solver(50, 11)
end

M:run()
