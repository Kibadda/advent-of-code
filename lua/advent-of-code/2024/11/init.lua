--- @class AOCDay202411: AOCDay
--- @field input integer[]
local M = require("advent-of-code.AOCDay"):new("2024", "11")

--- @param lines string[]
function M:parse(lines)
  self.input = lines[1]:only_ints()
end

local StoneCache = {}

--- @param blinks integer
function M:solver(blinks)
  local function calculate(stone, remaining_blinks, cache)
    cache = cache or {}
    local key = ("%s|%s"):format(stone, remaining_blinks)

    if remaining_blinks == 0 then
      return 1
    elseif cache[key] then
      return cache[key]
    end

    local count
    local s = tostring(stone)
    if stone == 0 then
      count = calculate(1, remaining_blinks - 1, cache)
    elseif #s % 2 == 0 then
      count = calculate(tonumber(s:sub(1, #s / 2)), remaining_blinks - 1, cache)
        + calculate(tonumber(s:sub(#s / 2 + 1)), remaining_blinks - 1, cache)
    else
      count = calculate(stone * 2024, remaining_blinks - 1, cache)
    end

    cache[key] = count
    return count
  end

  return table.reduce(self.input, 0, function(sum, stone)
    return sum + calculate(stone, blinks, StoneCache)
  end)
end

function M:solve1()
  return self:solver(25)
end

function M:solve2()
  return self:solver(75)
end

M:run()
