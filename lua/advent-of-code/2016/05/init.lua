local AOC = require "advent-of-code.AOC"
AOC.reload()

local md5 = require "advent-of-code.helpers.md5"

local M = AOC.create("2016", "05")

function M:parse(file)
  for line in file:lines() do
    self.input = line
  end
end

function M:solve1()
  local i = -1
  local pass = ""
  for _ = 1, 8 do
    local hash
    repeat
      i = i + 1
      hash = md5.sumhexa(self.input .. i)
    until hash:sub(1, 5) == "00000"
    pass = pass .. hash:at(6)
  end

  self.solution:add("1", pass)
end

function M:solve2()
  local i = -1
  local pass = {}
  repeat
    local hash
    repeat
      i = i + 1
      hash = md5.sumhexa(self.input .. i)
    until hash:sub(1, 5) == "00000"
    local number = tonumber(hash:at(6))
    if number and number >= 0 and number <= 7 and pass[number + 1] == nil then
      pass[number + 1] = hash:at(7)
    end
  until table.count(pass) == 8

  self.solution:add("2", table.concat(pass, ""))
end

M:run()

return M
