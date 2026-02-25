--- @class AOCDay202402: AOCDay
--- @field input integer[][]
local M = require("advent-of-code.AOCDay"):new("2024", "02")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:only_ints())
  end
end

function M:solver(report)
  local is_increasing = report[1] < report[2]

  for i = 2, #report do
    if
      not table.contains({ 1, 2, 3 }, math.abs(report[i - 1] - report[i]))
      or report[i - 1] < report[i] ~= is_increasing
    then
      return false
    end
  end

  return true
end

function M:solve1()
  return table.reduce(self.input, 0, function(safe, report)
    return safe + (self:solver(report) and 1 or 0)
  end)
end

function M:solve2()
  return table.reduce(self.input, 0, function(safe, report)
    if self:solver(report) then
      return safe + 1
    end

    for i = 1, #report do
      local c = table.deepcopy(report)
      table.remove(c, i)

      if self:solver(c) then
        return safe + 1
      end
    end

    return safe
  end)
end

M:run()
