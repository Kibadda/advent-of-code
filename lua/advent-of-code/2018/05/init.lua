--- @class AOCDay201805: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2018", "05")

--- @param lines string[]
function M:parse(lines)
  self.input = lines[1]
end

function M:solver(polymer)
  local changes = false
  local i = 1

  while true do
    local a = polymer:at(i)
    local b = polymer:at(i + 1)

    if a and b and a:lower() == b:lower() and a ~= b then
      polymer = polymer:sub(1, i - 1) .. polymer:sub(i + 2)
      changes = true
    else
      i = i + 1
    end

    if i > #polymer then
      break
    end
  end

  if not changes then
    return #polymer
  end

  return self:solver(polymer)
end

function M:solve1()
  return self:solver(self.input)
end

function M:solve2()
  return table.reduce(("abcdefghijklmnopqrstuvwxyz"):to_list(), math.huge, function(shortest, character)
    local polymer = self.input:gsub("[" .. character .. character:upper() .. "]", "")

    if #polymer == #self.input then
      return shortest
    end

    local length = self:solver(polymer)
    return length < shortest and length or shortest
  end)
end

M:run()
