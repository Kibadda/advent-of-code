--- @class AOCDay201809: AOCDay
--- @field input { players: integer, last: integer }
local M = require("advent-of-code.AOCDay"):new("2018", "09")

--- @param lines string[]
function M:parse(lines)
  local ints = lines[1]:only_ints()
  self.input = {
    players = ints[1],
    last = ints[2],
  }
end

function M:solver(multiplier)
  --- @class AOCDay201809Data
  --- @field value integer
  --- @field last AOCDay201809Data
  --- @field next AOCDay201809Data

  --- @type AOCDay201809Data
  --- @diagnostic disable-next-line:missing-fields
  local current = { value = 0 }
  current.last = current
  current.next = current

  local scores = {}

  for i = 1, self.input.last * multiplier do
    if i % 23 == 0 then
      local player = (i - 1) % self.input.players + 1
      for _ = 1, 7 do
        current = current.last
      end
      scores[player] = (scores[player] or 0) + i + current.value

      current.last.next = current.next
      current.next.last = current.last
      current = current.next
    else
      current = current.next
      local marble = {
        value = i,
        next = current.next,
        last = current,
      }
      current = marble
      current.last.next = marble
      current.next.last = marble
    end
  end

  return table.reduce(scores, -math.huge, function(max, score)
    return math.max(max, score)
  end, pairs)
end

function M:solve1()
  return self:solver(1)
end

function M:solve2()
  return self:solver(100)
end

M:run()
