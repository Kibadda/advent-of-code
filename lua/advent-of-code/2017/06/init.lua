--- @class AOCDay201706: AOCDay
--- @field input integer[]
local M = require("advent-of-code.AOCDay"):new("2017", "06")

--- @param lines string[]
function M:parse(lines)
  self.input = lines[1]:only_ints()
end

function M:solver(puzzle)
  local banks = table.deepcopy(self.input)
  local mem = {}
  local length = #banks
  local rounds = 0
  local cycle = nil
  while true do
    rounds = rounds + 1
    local max = table.reduce(banks, { blocks = -math.huge, index = nil }, function(carry, blocks, index)
      if blocks > carry.blocks then
        return { blocks = blocks, index = index }
      else
        return carry
      end
    end)

    local blocks = max.blocks
    banks[max.index] = 0
    local index = max.index + 1
    while blocks > 0 do
      if index > length then
        index = 1
      end
      banks[index] = banks[index] + 1
      index = index + 1
      blocks = blocks - 1
    end

    local str = table.concat(banks, "|")
    if mem[str] then
      cycle = rounds - mem[str]
      break
    end

    mem[str] = rounds
  end

  return puzzle == 1 and rounds or cycle
end

function M:solve1()
  return self:solver(1)
end

function M:solve2()
  return self:solver(2)
end

M:run()
