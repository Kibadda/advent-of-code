--- @class AOCDay202505: AOCDay
--- @field input { ranges: table, ingridients: table }
local M = require("advent-of-code.AOCDay"):new("2025", "05")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    ranges = {},
    ingridients = {},
  }

  local parsing_ranges = true
  for _, line in ipairs(lines) do
    if line == "" then
      parsing_ranges = false
    elseif parsing_ranges then
      table.insert(
        self.input.ranges,
        table.map(line:split "-", function(n)
          return tonumber(n)
        end)
      )
    else
      table.insert(self.input.ingridients, tonumber(line))
    end
  end
end

function M:solve1()
  local fresh = 0

  for _, ingridient in ipairs(self.input.ingridients) do
    local is_fresh = false

    for _, range in ipairs(self.input.ranges) do
      if ingridient >= range[1] and ingridient <= range[2] then
        is_fresh = true
        break
      end
    end

    if is_fresh then
      fresh = fresh + 1
    end
  end

  return fresh
end

function M:solve2()
  local ids = {}

  for _, range in ipairs(self.input.ranges) do
    ids[range[1]] = (ids[range[1]] or 0) + 1
    ids[range[2]] = (ids[range[2]] or 0) - 1
  end

  local count = 0
  local level = 0
  local s
  for id, type in spairs(ids) do
    if level == 0 then
      s = id
      level = type
    elseif level + type > 0 then
      ids[id] = nil
      level = level + type
    else
      ids[s] = 1
      ids[id] = -1
      level = 0
    end
  end

  local g
  for id, type in spairs(ids) do
    if type ~= 0 then
      if not g then
        g = id
      else
        count = count + id - g + 1
        g = nil
      end
    else
      count = count + 1
    end
  end

  return count
end

M:run()
