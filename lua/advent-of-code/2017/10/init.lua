local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "10")

function M:parse_input(file)
  for line in file:lines() do
    self.input = line
  end
end

function M:solver(max, lengths, rounds)
  local chain = {}
  for i = 1, max do
    chain[i] = i - 1
  end

  local index = 1
  local skip = 0
  for _ = 1, rounds do
    for _, length in ipairs(lengths) do
      local rev = {}
      for i = 0, length - 1 do
        if index + i > #chain then
          table.insert(rev, 1, chain[index + i - #chain])
        else
          table.insert(rev, 1, chain[index + i])
        end
      end
      for i = 0, length - 1 do
        if index + i > #chain then
          chain[index + i - #chain] = rev[i + 1]
        else
          chain[index + i] = rev[i + 1]
        end
      end
      index = index + length + skip
      while index > #chain do
        index = index - #chain
      end
      skip = skip + 1
    end
  end
  return chain
end

function M:solve1(max)
  local chain = self:solver(max, self.input:only_ints(), 1)
  self.solution:add("1", chain[1] * chain[2])
end

function M:solve2(max)
  local lengths = {}
  for i, c in ipairs(self.input:to_list()) do
    lengths[i] = string.byte(c)
  end
  for _, c in ipairs { 17, 31, 73, 47, 23 } do
    lengths[#lengths + 1] = c
  end

  local sparse = self:solver(max, lengths, 64)

  local dense = table.map(table.to_chunks(sparse, 16), function(chunk)
    return bit.tohex(
      table.reduce(chunk, 0, function(carry, i)
        return bit.bxor(carry, i)
      end),
      2
    )
  end)

  self.solution:add("2", table.concat(dense))
end

M:run(false, { 5, 256 }, { 256, 256 })

return M
