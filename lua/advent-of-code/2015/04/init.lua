local AOC = require "advent-of-code.AOC"
AOC.reload()

local md5 = require "advent-of-code.helpers.md5"

local M = AOC.create("2015", "04")

function M:solver(ending)
  local secret = self.input[1]
  local hash

  local i = -1
  repeat
    i = i + 1
    hash = md5.sumhexa(secret .. i)
  until hash:sub(1, 5) == ending

  return i
end

function M:solve1()
  self.solution:add("1", self:solver "00000")
end

function M:solve2()
  self.solution:add("2", self:solver "000000")
end

M:run()

return M
