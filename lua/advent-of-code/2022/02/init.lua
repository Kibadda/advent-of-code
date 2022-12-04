local AOCDay = require "advent-of-code.AOCDay"

local M = AOCDay:new("2022", "02")

-- function string:split(sep)
--   sep = sep or "%s"
--   local t = {}
--   for str in self:gmatch("([^" .. sep .. "]+)") do
--     table.insert(t, str)
--   end
--   return t
-- end

function string:shape_to_score()
  if self == "X" or self == "A" then
    return 1
  elseif self == "Y" or self == "B" then
    return 2
  else
    return 3
  end
end

function M:solve1()
  local score = 0

  for _, line in ipairs(self.lines) do
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
    score = score + split[2]:shape_to_score()
  end

  return score
end

function string:shape_to_result(win)
  if self == "A" then
    return win and "Y" or "Z"
  elseif self == "B" then
    return win and "Z" or "X"
  else
    return win and "X" or "Y"
  end
end

function M:solve2()
  local score = 0

  for _, line in ipairs(self.lines) do
    local split = line:split()

    if split[2] == "X" then
      score = score + split[1]:shape_to_result(false):shape_to_score()
    elseif split[2] == "Y" then
      score = score + 3 + split[1]:shape_to_score()
    else
      score = score + 6 + split[1]:shape_to_result(true):shape_to_score()
    end
  end

  return score
end

return M
