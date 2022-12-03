local AOCDay = require "advent-of-code.AOCDay"

local M = AOCDay:new("2022", "03")

function string:to_priority()
  local byte = self:byte()

  if byte <= 95 then
    byte = byte - string.byte "A" + 27
  else
    byte = byte - string.byte "a" + 1
  end

  return byte
end

function M:solve1()
  local rucksacks = {}

  for _, line in ipairs(self.lines) do
    local item = {
      one = {},
      two = {},
    }
    local str_length = #line
    local i = 1

    for c in line:gmatch "." do
      if i <= str_length / 2 then
        table.insert(item.one, c)
      else
        table.insert(item.two, c)
      end
      i = i + 1
    end

    table.insert(rucksacks, item)
  end

  local total_priority = 0

  for _, items in ipairs(rucksacks) do
    local same_c = nil
    for _, c1 in ipairs(items.one) do
      for _, c2 in ipairs(items.two) do
        if c1 == c2 then
          same_c = c1
          break
        end
      end
      if same_c ~= nil then
        break
      end
    end

    total_priority = total_priority + same_c:to_priority()
  end

  return total_priority
end

function M:solve2()
  local groups = {}

  local i = 0
  local group = {}
  for _, line in ipairs(self.lines) do
    table.insert(group, line)
    i = i + 1

    if i % 3 == 0 then
      table.insert(groups, group)
      group = {}
    end
  end

  local total_priority = 0

  for _, rucksack_group in ipairs(groups) do
    local same_c = nil
    for c1 in rucksack_group[1]:gmatch "." do
      for c2 in rucksack_group[2]:gmatch "." do
        for c3 in rucksack_group[3]:gmatch "." do
          if c1 == c2 and c2 == c3 then
            same_c = c1
            break
          end
        end
        if same_c ~= nil then
          break
        end
      end
      if same_c ~= nil then
        break
      end
    end

    total_priority = total_priority + same_c:to_priority()
  end

  return total_priority
end

return M
