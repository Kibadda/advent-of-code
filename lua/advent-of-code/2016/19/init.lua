--- @class AOCDay201619: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2016", "19")

function M:solve1()
  local length = tonumber(self.input[1])

  local presents = {}
  for i = 1, length do
    presents[i] = 1
  end
  local current = 1

  local function nex(index)
    repeat
      index = index + 1
      if index > length then
        index = 1
      end
    until presents[index] > 0
    return index
  end

  while true do
    if presents[current] == length then
      break
    end

    local next = nex(current)
    presents[current] = presents[current] + presents[next]
    presents[next] = 0

    current = nex(current)
  end
  return current
end

function M:solve2()
  local presents = {}
  for i = 1, tonumber(self.input[1]) do
    presents[i] = i
  end
  local current = 1

  local length = #presents
  while length > 1 do
    local steal = current + math.floor(length / 2)
    if steal > length then
      steal = steal - length
    end

    table.remove(presents, steal)
    length = length - 1
    if current < steal then
      current = current + 1
    end
    if current > length then
      current = 1
    end
  end
  return presents[1]
end

M:run()
