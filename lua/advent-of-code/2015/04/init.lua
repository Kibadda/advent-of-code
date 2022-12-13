local AOC = require "advent-of-code.AOC"
AOC.reload()

local md5 = require "advent-of-code.2015.04.md5"

local M = AOC.create("2015", "04")

function M:solve1()
  local secret = self.input[1]
  local hash

  local i = -1
  repeat
    i = i + 1
    hash = md5.sumhexa(secret .. i)
  until hash:sub(1, 5) == "00000"

  self.solution:add("one", i)
end

function M:solve2()
  local secret = self.input[1]
  local hash

  local i = -1
  repeat
    i = i + 1
    hash = md5.sumhexa(secret .. i)
  until hash:sub(1, 6) == "000000"

  self.solution:add("two", i)
end

M:run(false)

return M
