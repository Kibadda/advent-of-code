--- @class AOCDay202220: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2022", "20")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, tonumber(line))
  end
end

function M:solver(multiplier, shuffle)
  local original = table.map(self.input, function(n, i)
    return string.format("%d|%d", i, n * multiplier)
  end)
  local numbers = table.deepcopy(original)
  local count = table.count(numbers)

  local function move(from, to)
    if to == 1 then
      to = count
    end

    if from < to then
      table.insert(numbers, to + 1, numbers[from])
      table.remove(numbers, from)
    else
      table.insert(numbers, to, numbers[from])
      table.remove(numbers, from + 1)
    end
  end

  for _ = 1, shuffle do
    for _, val in ipairs(original) do
      local cur = table.find(numbers, val)
      local num = assert(tonumber(string.split(val, "|")[2]))
      local new = cur + num

      if new >= 1 and new <= count then
        move(cur, new)
      else
        move(cur, ((new - 1) % (count - 1)) + 1)
      end
    end
  end

  local zero
  for i, val in ipairs(numbers) do
    if tonumber(val:split("|")[2]) == 0 then
      zero = i
      break
    end
  end

  local one = numbers[((zero + 999) % count) + 1]:split("|")[2]
  local two = numbers[((zero + 1999) % count) + 1]:split("|")[2]
  local three = numbers[((zero + 2999) % count) + 1]:split("|")[2]

  return one + two + three
end

function M:solve1()
  return self:solver(1, 1)
end

function M:solve2()
  return self:solver(811589153, 10)
end

M:run()
