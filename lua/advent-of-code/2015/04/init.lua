local AOC = require "advent-of-code.AOC"
AOC.reload()

local md5 = require "advent-of-code.helpers.md5"

---@class AOCDay201504: AOCDay
---@field input string[]
local M = AOC.create("2015", "04")

---@param file file*
function M:parse(file)
  self.input = file:read()
end

---@param prefix string
function M:solver(prefix)
  local hash
  local i = 0

  while true do
    hash = md5.sumhexa(self.input .. i)

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

return M
