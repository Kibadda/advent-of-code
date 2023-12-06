local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "20")

function M:parse(file)
  local i = 0
  for line in file:lines() do
    i = i + 1
    table.insert(self.input, ("%d|%d"):format(i, line))
  end
end

local function move(t, from, to)
  if from < to then
    table.insert(t, to + 1, t[from])
    table.remove(t, from)
  else
    table.insert(t, to, t[from])
    table.remove(t, from + 1)
  end
end

function M:solve1()
  local numbers = table.deepcopy(self.input)
  for _, val in ipairs(self.input) do
    local cur = table.find(numbers, val)
    local num = tonumber(val:split("|")[2])
    local new
    if num < 0 then
      if cur + num < 1 then
        new = (cur + num - 1) % table.count(numbers)
      else
        new = cur + num
      end
    elseif num > 0 then
      if cur + num > table.count(numbers) then
        new = (cur + num + 1) % table.count(numbers)
      else
        new = cur + num
      end
    end

    if new ~= nil then
      move(numbers, cur, new)
    end
  end

  local zero_index
  for i, val in ipairs(numbers) do
    if tonumber(val:split("|")[2]) == 0 then
      zero_index = i
      break
    end
  end

  local one = numbers[(zero_index + 1000) % table.count(numbers)]:split("|")[2]
  local two = numbers[(zero_index + 2000) % table.count(numbers)]:split("|")[2]
  local three = numbers[(zero_index + 3000) % table.count(numbers)]:split("|")[2]

  self.solution:add("1", one + two + three)
end

function M:solve2()
  self.solution:add("2", nil)
end

M:run()

return M
