local AOCDay = require "advent-of-code.AOCDay"

local M = AOCDay("2022", "01")

local function spairs(t)
  local keys = {}
  for k in pairs(t) do
    keys[#keys + 1] = k
  end

  table.sort(keys, function(a, b)
    return t[b] < t[a]
  end)

  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], t[keys[i]]
    end
  end
end

function M:parse_input()
  local elves = {}
  table.insert(elves, 0)

  local current_pos = 1
  for _, line in ipairs(self.lines) do
    local number = tonumber(line)
    if number == nil then
      table.insert(elves, 0)
      current_pos = current_pos + 1
    else
      elves[current_pos] = elves[current_pos] + number
    end
  end

  return elves
end

function M:solve1()
  local _, max = spairs(self:parse_input())()
  return max
end

function M:solve2()
  local next = spairs(self:parse_input())
  local _, one = next()
  local _, two = next()
  local _, three = next()
  return one + two + three
end

return M
