local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay202307: AOCDay
---@field input { hand: string, bid: integer, type: integer }[]
local M = AOC.create("2023", "07")

local MAPPING = {
  A = 1,
  K = 2,
  Q = 3,
  J = 4,
  T = 5,
  ["9"] = 6,
  ["8"] = 7,
  ["7"] = 8,
  ["6"] = 9,
  ["5"] = 10,
  ["4"] = 11,
  ["3"] = 12,
  ["2"] = 13,
}

local TYPE = {
  FIVE = 1,
  FOUR = 2,
  FULL = 3,
  THREE = 4,
  TWO_PAIR = 5,
  ONE_PAIR = 6,
  HIGH = 7,
}

---@param file file*
function M:parse(file)
  for line in file:lines() do
    local split = line:split()
    table.insert(self.input, {
      hand = split[1],
      bid = tonumber(split[2]),
      type = 0,
    })
  end
end

---@param func fun(hand: string): integer
---@return integer
function M:solver(func)
  for _, card in ipairs(self.input) do
    card.type = func(card.hand)
  end

  table.sort(self.input, function(a, b)
    if a.type ~= b.type then
      return a.type > b.type
    end

    for i = 1, #a.hand do
      if a.hand:at(i) ~= b.hand:at(i) then
        return MAPPING[a.hand:at(i)] > MAPPING[b.hand:at(i)]
      end
    end

    return false
  end)

  return table.reduce(self.input, 0, function(winnings, card, i)
    return winnings + card.bid * i
  end)
end

function M:solve1()
  return self:solver(function(hand)
    local frequencies = table.frequencies(hand:to_list())
    local uniques = table.count(frequencies)

    if uniques == 1 then
      return TYPE.FIVE
    elseif uniques == 2 then
      if
        table.reduce(frequencies, 0, function(max, count)
          return math.max(max, count)
        end, pairs) == 4
      then
        return TYPE.FOUR
      else
        return TYPE.FULL
      end
    elseif uniques == 3 then
      if
        table.reduce(frequencies, 0, function(max, count)
          return math.max(max, count)
        end, pairs) == 3
      then
        return TYPE.THREE
      else
        return TYPE.TWO_PAIR
      end
    elseif uniques == 4 then
      return TYPE.ONE_PAIR
    else
      return TYPE.HIGH
    end
  end)
end

function M:solve2()
  MAPPING.J = 14

  return self:solver(function(hand)
    local frequencies = table.frequencies(hand:to_list())
    local uniques = table.count(frequencies)
    local _, joker_count = hand:gsub("J", "Z")

    if uniques == 1 then
      return TYPE.FIVE
    elseif uniques == 2 then
      if joker_count > 0 then
        return TYPE.FIVE
      elseif
        table.reduce(frequencies, 0, function(max, count)
          return math.max(max, count)
        end, pairs) == 4
      then
        return TYPE.FOUR
      else
        return TYPE.FULL
      end
    elseif uniques == 3 then
      local max_count = table.reduce(frequencies, 0, function(max, count)
        return math.max(max, count)
      end, pairs)

      if max_count == joker_count then
        return TYPE.FOUR
      elseif joker_count > 0 then
        if max_count == 3 then
          return TYPE.FOUR
        else
          return TYPE.FULL
        end
      else
        if
          table.reduce(frequencies, 0, function(max, count)
            return math.max(max, count)
          end, pairs) == 3
        then
          return TYPE.THREE
        else
          return TYPE.TWO_PAIR
        end
      end
    elseif uniques == 4 then
      if joker_count > 0 then
        return TYPE.THREE
      else
        return TYPE.ONE_PAIR
      end
    else
      if joker_count > 0 then
        return TYPE.ONE_PAIR
      else
        return TYPE.HIGH
      end
    end
  end)
end

M:run()

return M
