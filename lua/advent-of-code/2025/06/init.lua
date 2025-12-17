--- @class AOCDay202506: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2025", "06")

function M:solver(cols)
  return table.sum(table.map(cols, function(col)
    return match(col.operator) {
      ["+"] = table.sum(col),
      ["*"] = table.prod(col),
    }
  end))
end

function M:solve1()
  local cols = {}

  for i, line in ipairs(self.input) do
    if i == #self.input then
      for j, c in ipairs(line:split "%s") do
        cols[j].operator = c
      end
    else
      for j, c in ipairs(line:only_ints()) do
        cols[j] = cols[j] or {}
        table.insert(cols[j], tonumber(c))
      end
    end
  end

  return self:solver(cols)
end

function M:solve2()
  local cols = {}
  local numbers = {}

  for i = #self.input[1], 1, -1 do
    local only_whitespace = true
    local number = 0

    for j = 1, #self.input - 1 do
      if self.input[j]:at(i) ~= " " then
        number = number * 10 + tonumber(self.input[j]:at(i))
        only_whitespace = false
      end
    end

    if number > 0 then
      table.insert(numbers, number)
    end

    if only_whitespace then
      table.insert(cols, numbers)
      numbers = {}
    end

    if self.input[#self.input]:at(i) ~= " " then
      numbers.operator = self.input[#self.input]:at(i)
    end
  end

  table.insert(cols, numbers)

  return self:solver(cols)
end

M:run()
