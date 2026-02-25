--- @class AOCDay202405: AOCDay
--- @field input { ordering: table<integer, integer[]>, updates: integer[][] }
local M = require("advent-of-code.AOCDay"):new("2024", "05")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    ordering = {},
    updates = {},
  }

  local parsing_ordering = true
  for _, line in ipairs(lines) do
    if line == "" then
      parsing_ordering = false
    elseif parsing_ordering then
      local key, value = unpack(line:only_ints())

      self.input.ordering[key] = self.input.ordering[key] or {}
      table.insert(self.input.ordering[key], value)
    else
      table.insert(self.input.updates, table.reverse(line:only_ints()))
    end
  end
end

function M:solver(update)
  for i = 1, #update do
    for j = i + 1, #update do
      if self.input.ordering[update[i]] and table.contains(self.input.ordering[update[i]], update[j]) then
        return false
      end
    end
  end

  return true
end

function M:solve1()
  return table.reduce(self.input.updates, 0, function(sum, update)
    if self:solver(update) then
      return sum + update[math.floor(#update / 2) + 1]
    end

    return sum
  end)
end

function M:solve2()
  return table.reduce(self.input.updates, 0, function(sum, update)
    if self:solver(update) then
      return sum
    end

    table.sort(update, function(a, b)
      return self.input.ordering[a] and table.contains(self.input.ordering[a], b)
    end)

    return sum + update[math.floor(#update / 2) + 1]
  end)
end

M:run()
