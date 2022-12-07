local AOCDay = require "advent-of-code.AOCDay"

local M = AOCDay:new("2015", "03")

function M:solve1()
  local houses = 1
  local pos = { 0, 0 }
  local grid = { ["0"] = { ["0"] = true } }
  for c in self.lines[1]:gmatch "." do
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
      houses = houses + 1
      grid[x][y] = true
    end
  end

  return houses
end

function M:solve2()
  local houses = 1
  local santa_pos = { 0, 0 }
  local robo_pos = { 0, 0 }
  local grid = { ["0"] = { ["0"] = true } }
  local turn = "santa"
  for c in self.lines[1]:gmatch "." do
    local x, y
    if turn == "santa" then
      if c == "^" then
        santa_pos[1] = santa_pos[1] + 1
      elseif c == "v" then
        santa_pos[1] = santa_pos[1] - 1
      elseif c == ">" then
        santa_pos[2] = santa_pos[2] + 1
      elseif c == "<" then
        santa_pos[2] = santa_pos[2] - 1
      end
      turn = "robo"
      x = tostring(santa_pos[1])
      y = tostring(santa_pos[2])
    else
      if c == "^" then
        robo_pos[1] = robo_pos[1] + 1
      elseif c == "v" then
        robo_pos[1] = robo_pos[1] - 1
      elseif c == ">" then
        robo_pos[2] = robo_pos[2] + 1
      elseif c == "<" then
        robo_pos[2] = robo_pos[2] - 1
      end
      turn = "santa"
      x = tostring(robo_pos[1])
      y = tostring(robo_pos[2])
    end
    if grid[x] == nil then
      grid[x] = {}
    end
    if grid[x][y] == nil then
      houses = houses + 1
      grid[x][y] = true
    end
  end

  return houses
end

return M
