local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "19")

function M:parse_input(file)
  for line in file:lines() do
    self.input[#self.input + 1] = line
  end
end

function M:solver()
  local pos
  for i = 1, #self.input[1] do
    if self.input[1]:at(i) ~= " " then
      pos = V(1, i)
      break
    end
  end
  local direction = V(1, 0)

  local path = ""
  local steps = 1

  while true do
    pos = pos + direction

    if
      pos.x < 1
      or pos.x > #self.input
      or pos.y < 1
      or pos.y > #self.input[1]
      or self.input[pos.x]:at(pos.y) == " "
    then
      break
    end

    steps = steps + 1

    if self.input[pos.x]:at(pos.y) == "+" then
      if direction.x == 0 then
        if self.input[pos.x - 1] and self.input[pos.x - 1]:at(pos.y) ~= " " then
          direction = V(-1, 0)
        else
          direction = V(1, 0)
        end
      else
        if self.input[pos.x]:at(pos.y - 1) and self.input[pos.x]:at(pos.y - 1) ~= " " then
          direction = V(0, -1)
        else
          direction = V(0, 1)
        end
      end
    end

    if self.input[pos.x]:at(pos.y):byte() >= 65 and self.input[pos.x]:at(pos.y):byte() <= 90 then
      path = path .. self.input[pos.x]:at(pos.y)
    end
  end

  return { path = path, steps = steps }
end

function M:solve1()
  self.solution:add("1", self:solver().path)
end

function M:solve2()
  self.solution:add("2", self:solver().steps)
end

M:run(false)

return M
