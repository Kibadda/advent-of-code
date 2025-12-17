--- @class AOCDay202309: AOCDay
--- @field input integer[][]
local M = require("advent-of-code.AOCDay"):new("2023", "09")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:only_ints "-?%d+")
  end
end

--- @param reverse? boolean
--- @return integer
function M:solver(reverse)
  local total = 0

  for _, numbers in ipairs(self.input) do
    local sequences = reverse and { table.reverse(numbers) } or { numbers }
    local index = 1

    while
      not table.reduce(sequences[index], true, function(is_zero, number)
        return is_zero and (number == 0)
      end)
    do
      local sequence = {}
      for i = 1, #sequences[index] - 1 do
        table.insert(sequence, sequences[index][i + 1] - sequences[index][i])
      end

      table.insert(sequences, sequence)
      index = index + 1
    end

    local new_value = 0
    for i = #sequences - 1, 1, -1 do
      new_value = sequences[i][#sequences[i]] + new_value
    end

    total = total + new_value
  end

  return total
end

function M:solve1()
  return self:solver()
end

function M:solve2()
  return self:solver(true)
end

M:run()
