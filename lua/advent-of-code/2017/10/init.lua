--- @class AOCDay201710: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2017", "10")

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

function M:solve1()
  local chain = self:solver(self.test and 5 or 256, self.input[1]:only_ints(), 1)
  return chain[1] * chain[2]
end

function M:solve2()
  local lengths = {}
  for i, c in ipairs(self.input[1]:to_list()) do
    lengths[i] = string.byte(c)
  end
  for _, c in ipairs { 17, 31, 73, 47, 23 } do
    lengths[#lengths + 1] = c
  end

  local sparse = self:solver(256, lengths, 64)

  local dense = table.map(table.to_chunks(sparse, 16), function(chunk)
    return bit.tohex(
      table.reduce(chunk, 0, function(carry, i)
        return bit.bxor(carry, i)
      end),
      2
    )
  end)

  return table.concat(dense)
end

M:run()
