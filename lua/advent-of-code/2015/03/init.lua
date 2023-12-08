local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay201503: AOCDay
---@field input string
local M = AOC.create("2015", "03")

---@param file file*
function M:parse(file)
  self.input = file:read()
end

---@param sleighs integer
function M:solver(sleighs)
  ---@type Vector[]
  local pos = {}
  for _ = 1, sleighs do
    table.insert(pos, V(0, 0))
  end

  local iter = cycle(pos)
  local index = 1

  local grid = {}
  local houses = 0

  for _, c in ipairs(self.input:to_list()) do
    if c == "^" then
      pos[index] = pos[index] + V(1, 0)
    elseif c == "v" then
      pos[index] = pos[index] + V(-1, 0)
    elseif c == ">" then
      pos[index] = pos[index] + V(0, 1)
    elseif c == "<" then
      pos[index] = pos[index] + V(0, -1)
    end

    if not grid[pos[index]:string()] then
      houses = houses + 1
    end

    grid[pos[index]:string()] = true

    index = iter(pos, index)
  end

  return houses
end

function M:solve1()
  return self:solver(1)
end

function M:solve2()
  return self:solver(2)
end

M:run()

return M
