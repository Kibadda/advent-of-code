--- @class AOCDay201904: AOCDay
--- @field input { [1]: integer, [2]: integer }
local M = require("advent-of-code.AOCDay"):new("2019", "04")

--- @param lines string[]
function M:parse(lines)
  self.input = lines[1]:only_ints()
end

function M:solve1()
  local count = 0

  for i = self.input[1], self.input[2] do
    local split = tostring(i):to_list()

    local decrease = true
    local double = false
    for j = 2, #split do
      if split[j - 1] > split[j] then
        decrease = false
        break
      end

      if split[j - 1] == split[j] then
        double = true
      end
    end

    if decrease and double then
      count = count + 1
    end
  end

  return count
end

function M:solve2()
  local count = 0

  for i = self.input[1], self.input[2] do
    local split = tostring(i):to_list()

    local decrease = true
    local double = false
    local number

    for j = 1, #split - 1 do
      if split[j] > split[j + 1] then
        decrease = false
        break
      end

      if split[j] ~= number and split[j] == split[j + 1] and split[j] ~= split[j + 2] then
        double = true
      end

      if split[j] ~= number and split[j] == split[j + 1] then
        if split[j] ~= split[j + 2] then
          double = true
        else
          number = split[j]
        end
      end
    end

    if decrease and double then
      count = count + 1
    end
  end

  return count
end

M:run()
