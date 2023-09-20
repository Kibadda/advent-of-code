local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "06")

function M:parse_input(file)
  for line in file:lines() do
    self.input = line:only_ints()
  end
end

function M:solve1()
  local banks = table.deepcopy(self.input)
  local mem = {}
  local length = #banks
  local rounds = 0
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
      break
    end

    mem[str] = true
  end
  self.solution:add("1", rounds)
end

function M:solve2()
  local banks = table.deepcopy(self.input)
  local mem = {}
  local length = #banks
  local rounds = 0
  local cycle
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
  self.solution:add("2", cycle)
end

M:run(false)

return M
