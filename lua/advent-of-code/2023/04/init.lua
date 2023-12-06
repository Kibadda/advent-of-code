local AOC = require "advent-of-code.AOC"
AOC.reload()

---@alias scratchcard { count: integer, winning: integer[], own: integer[] }

---@class AOC202304: AOCDay
---@field input scratchcard[]
local M = AOC.create("2023", "04")

function M:parse_input(file)
  for line in file:lines() do
    local ints = line:only_ints()

    table.insert(self.input, {
      count = 1,
      winning = { unpack(ints, 2, self.test and 6 or 11) },
      own = { unpack(ints, self.test and 7 or 12) },
    })
  end
end

---@param func fun(card: scratchcard, i: integer): integer
function M:solver(func)
  return table.reduce(self.input, 0, function(total, card, i)
    return total + func(card, i)
  end)
end

function M:solve1()
  return self:solver(function(card)
    local count = #table.intersection(card.own, card.winning)
    return count == 0 and 0 or math.pow(2, count - 1)
  end)
end

function M:solve2()
  return self:solver(function(card, i)
    for j = i + 1, i + #table.intersection(card.own, card.winning) do
      self.input[j].count = self.input[j].count + card.count
    end

    return card.count
  end)
end

M:run()

return M
