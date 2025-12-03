--- @class AOCDay202503: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOC").create("2025", "03")

function M:solver(amount_banks)
  local joltage = 0

  for _, bank in ipairs(self.input) do
    local from = 0
    local digits = {}

    for i = 1, amount_banks do
      digits[i] = 0

      for j = from + 1, #bank - amount_banks + i do
        if tonumber(bank:at(j)) > digits[i] then
          from = j
          digits[i] = tonumber(bank:at(j))
        end
      end
    end

    joltage = joltage + tonumber(table.concat(digits, ""))
  end

  return joltage
end

function M:solve1()
  return self:solver(2)
end

function M:solve2()
  return self:solver(12)
end

M:run()
