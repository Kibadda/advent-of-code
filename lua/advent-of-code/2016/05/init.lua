--- @class AOCDay201605: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2016", "05")

function M:solve1()
  local i = -1
  local pass = ""
  for _ = 1, 8 do
    local hash
    repeat
      i = i + 1
      hash = MD5.sumhexa(self.input[1] .. i)
    until hash:sub(1, 5) == "00000"
    pass = pass .. hash:at(6)
  end

  return pass
end

function M:solve2()
  local i = -1
  local pass = {}
  repeat
    local hash
    repeat
      i = i + 1
      hash = MD5.sumhexa(self.input[1] .. i)
    until hash:sub(1, 5) == "00000"
    local number = tonumber(hash:at(6))
    if number and number >= 0 and number <= 7 and pass[number + 1] == nil then
      pass[number + 1] = hash:at(7)
    end
  until table.count(pass) == 8

  return table.concat(pass, "")
end

M:run()
