local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2023", "01")

function M:solver(first, last)
  return table.reduce(self.input, 0, function(sum, value)
    return sum + 10 * first(value) + last(value)
  end)
end

function M:solve1()
  self.solution:add(
    "1",
    self:solver(function(value)
      return table.reduce(value:to_list(), nil, function(number, character)
        return number or tonumber(character)
      end) or 0
    end, function(value)
      return table.reduce(value:reverse():to_list(), nil, function(number, character)
        return number or tonumber(character)
      end) or 0
    end)
  )
end

function M:solve2()
  ---@param value string
  local function get_string_number(value, reverse)
    local find = reverse and string.reversefind or string.find

    return table.reduce({
      { find(value, "one"), 1 },
      { find(value, "two"), 2 },
      { find(value, "three"), 3 },
      { find(value, "four"), 4 },
      { find(value, "five"), 5 },
      { find(value, "six"), 6 },
      { find(value, "seven"), 7 },
      { find(value, "eight"), 8 },
      { find(value, "nine"), 9 },
    }, { math.huge, nil }, function(carry, f)
      if f[1] and f[1] < carry[1] then
        return f
      end

      return carry
    end)
  end

  self.solution:add(
    "2",
    self:solver(function(value)
      local s = table.reduce(value:to_list(), nil, function(index, character, i)
        return (not index and tonumber(character)) and i or index
      end) or math.huge

      local f = get_string_number(value, false)
      if s < f[1] then
        return tonumber(value:at(s))
      else
        return f[2]
      end
    end, function(value)
      local e = table.reduce(value:reverse():to_list(), nil, function(index, character, i)
        return (not index and tonumber(character)) and i or index
      end) or math.huge

      local f = get_string_number(value, true)
      if e < f[1] then
        return tonumber(value:reverse():at(e))
      else
        return f[2]
      end
    end)
  )
end

M:run()

return M
