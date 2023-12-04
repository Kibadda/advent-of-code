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
  for i, card in ipairs(self.input) do
    local matches = 0

    for _, number in pairs(card.own) do
      for _, winner in ipairs(card.winning) do
        if number == winner then
          matches = matches + 1
          break
        end
      end
    end

    for j = i + 1, i + matches do
      self.input[j].count = self.input[j].count + card.count
    end
  end

  self.solution:add(
    "2",
    table.reduce(self.input, 0, function(carry, card)
      return carry + card.count
    end)
  )
end

M:run()

return M
