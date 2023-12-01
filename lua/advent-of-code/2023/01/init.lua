local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2023", "01")

function M:solver(first, last)
  local sum = 0

  for _, value in ipairs(self.input) do
    sum = sum + 10 * first(value) + last(value)
  end

  return sum
end

function M:solve1()
  self.solution:add(
    "1",
    self:solver(function(value)
      for i = 1, #value do
        if tonumber(value:at(i)) then
          return tonumber(value:at(i))
        end
      end

      return 0
    end, function(value)
      for i = #value, 1, -1 do
        if tonumber(value:at(i)) then
          return tonumber(value:at(i))
        end
      end

      return 0
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
      local s = math.huge
      for i = 1, #value do
        if tonumber(value:at(i)) then
          s = i
          break
        end
      end

      local f = get_string_number(value, false)
      if s < f[1] then
        return tonumber(value:at(s))
      else
        return f[2]
      end
    end, function(value)
      local rev = value:reverse()
      local e = math.huge
      for i = 1, #rev do
        if tonumber(rev:at(i)) then
          e = i
          break
        end
      end

      local f = get_string_number(value, true)
      if e < f[1] then
        return tonumber(rev:at(e))
      else
        return f[2]
      end
    end)
  )
end

M:run()

return M
