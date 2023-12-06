local AOC = require "advent-of-code.AOC"
AOC.reload()

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

function M:solve1()
  self.solution:add(
    "1",
    table.reduce(self.input, 0, function(total, card)
      return total
        + table.reduce(card.own, 0, function(points, number)
          if table.contains(card.winning, number) then
            points = points == 0 and 1 or points * 2
          end

          return points
        end)
    end)
  )
end

function M:solve2()
  self.solution:add(
    "2",
    table.reduce(self.input, 0, function(cards, card, i)
      for j = i + 1, i + #table.intersection(card.own, card.winning) do
        self.input[j].count = self.input[j].count + card.count
      end

      return cards + card.count
    end)
  )
end

M:run()

return M
