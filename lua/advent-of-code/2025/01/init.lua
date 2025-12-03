--- @class AOCDay202501: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOC").create("2025", "01")

function M:solve1()
  local pointer = 50
  local count = 0

  for _, line in ipairs(self.input) do
    local turn = tonumber(line:sub(2))

    if line:at(1) == "R" then
      pointer = pointer + turn
    elseif line:at(1) == "L" then
      pointer = pointer - turn
    end

    if pointer % 100 == 0 then
      count = count + 1
    end
  end

  return count
end

function M:solve2()
  local pointer = 50
  local count = 0

  for _, line in ipairs(self.input) do
    local before = pointer
    local turn = tonumber(line:sub(2))

    count = count + math.floor(turn / 100)

    turn = turn % 100

    if line:at(1) == "R" then
      pointer = pointer + turn
      if before % 100 > pointer % 100 then
        count = count + 1
      end
    elseif line:at(1) == "L" then
      pointer = pointer - turn
      if before % 100 ~= 0 and (before % 100 < pointer % 100 or pointer % 100 == 0) then
        count = count + 1
      end
    end
  end

  return count
end

M:run()
