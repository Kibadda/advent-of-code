local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "02")

local function shape_to_score(str)
  if str == "X" or str == "A" then
    return 1
  elseif str == "Y" or str == "B" then
    return 2
  else
    return 3
  end
end

local function shape_to_result(str, win)
  if str == "A" then
    return win and "Y" or "Z"
  elseif str == "B" then
    return win and "Z" or "X"
  else
    return win and "X" or "Y"
  end
end

function M:parse(file)
  self.__super.parse(self, file)
end

function M:solve1()
  local score = 0

  for _, line in ipairs(self.input) do
    local split = line:split()
    if
      (split[1] == "A" and split[2] == "X")
      or (split[1] == "B" and split[2] == "Y")
      or (split[1] == "C" and split[2] == "Z")
    then
      score = score + 3
    elseif
      (split[1] == "A" and split[2] == "Y")
      or (split[1] == "B" and split[2] == "Z")
      or (split[1] == "C" and split[2] == "X")
    then
      score = score + 6
    end
    score = score + shape_to_score(split[2])
  end

  self.solution:add("1", score)
end

function M:solve2()
  local score = 0

  for _, line in ipairs(self.input) do
    local split = line:split()

    if split[2] == "X" then
      score = score + shape_to_score(shape_to_result(split[1], false))
    elseif split[2] == "Y" then
      score = score + 3 + shape_to_score(split[1])
    else
      score = score + 6 + shape_to_score(shape_to_result(split[1], true))
    end
  end

  self.solution:add("2", score)
end

M:run()

return M
