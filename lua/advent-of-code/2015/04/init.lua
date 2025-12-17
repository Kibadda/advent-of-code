--- @class AOCDay201504: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2015", "04")

--- @param prefix string
function M:solver(prefix)
  local hash
  local i = 0

  while true do
    hash = MD5.sumhexa(self.input[1] .. i)

    if hash:startswith(prefix) then
      return i
    end

    i = i + 1
  end
end

function M:solve1()
  return self:solver "00000"
end

function M:solve2()
  return self:solver "000000"
end

M:run()
