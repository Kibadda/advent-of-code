--- @class AOCDay201525: AOCDay
--- @field input { row: number, col: number }
local M = require("advent-of-code.AOCDay"):new("2015", "25")

--- @param lines string[]
function M:parse(lines)
  local ints = lines[1]:only_ints()
  self.input = { row = ints[1], col = ints[2] }
end

function M:solve1()
  local number = 20151125
  local row = 1
  local col = 1

  while true do
    if row == 1 then
      row = col + 1
      col = 1
    else
      row = row - 1
      col = col + 1
    end

    number = (number * 252533) % 33554393

    if row == self.input.row and col == self.input.col then
      break
    end
  end

  return number
end

function M:solve2() end

M:run()
