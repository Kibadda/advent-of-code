local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "03")

function M:solver(c, pos, grid)
  if c == "^" then
    pos[1] = pos[1] + 1
  elseif c == "v" then
    pos[1] = pos[1] - 1
  elseif c == ">" then
    pos[2] = pos[2] + 1
  elseif c == "<" then
    pos[2] = pos[2] - 1
  end
  local x = tostring(pos[1])
  local y = tostring(pos[2])
  if grid[x] == nil then
    grid[x] = {}
  end
  if grid[x][y] == nil then
    grid[x][y] = true
    return true
  end
  return false
end

function M:solve1()
  local houses = 1
  local pos = { 0, 0 }
  local grid = { ["0"] = { ["0"] = true } }
  for _, c in ipairs(self.input[1]:to_list()) do
    if self:solver(c, pos, grid) then
      houses = houses + 1
    end
  end

  self.solution:add("1", houses)
end

function M:solve2()
  local houses = 1
  local santa_pos = { 0, 0 }
  local robo_pos = { 0, 0 }
  local grid = { ["0"] = { ["0"] = true } }
  local turn = "santa"
  for _, c in ipairs(self.input[1]:to_list()) do
    if self:solver(c, turn == "santa" and santa_pos or robo_pos, grid) then
      houses = houses + 1
    end
    turn = turn == "santa" and "robo" or "santa"
  end

  self.solution:add("2", houses)
end

M:run()

return M
