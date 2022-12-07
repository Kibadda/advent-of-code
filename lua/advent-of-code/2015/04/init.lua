local AOCDay = require "advent-of-code.AOCDay"

local md5 = require "advent-of-code.2015.04.md5"

local M = AOCDay:new("2015", "04")

function M:solve1()
  local secret = self.lines[1]
  local hash

  local i = -1
  repeat
    i = i + 1
    hash = md5.sumhexa(secret .. i)
  until hash:sub(1, 5) == "00000"

  return i
end

function M:solve2()
  local secret = self.lines[1]
  local hash

  local i = -1
  repeat
    i = i + 1
    hash = md5.sumhexa(secret .. i)
  until hash:sub(1, 6) == "000000"

  return i
end

return M
