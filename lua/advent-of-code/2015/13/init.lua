--- @class AOCDay201513: AOCDay
--- @field input table<string, table<string, number>>
local M = require("advent-of-code.AOC").create("2015", "13")

--- @param file file*
function M:parse(file)
  for line in file:lines() do
    local words = string.split(line, " ")

    self.input[words[1]] = self.input[words[1]] or {}

    local name = words[11]

    self.input[words[1]][name:sub(1, #name - 1)] = tonumber(words[4]) * (words[3] == "gain" and 1 or -1)
  end
end

function M:solver(persons)
  local count = table.count(persons)
  local start = { available = table.keys(persons), seating = {} }
  local queue = { start }

  local max = -math.huge

  while #queue > 0 do
    local current
    current = table.remove(queue)

    if #current.seating == count then
      local copy = table.deepcopy(current.seating)
      local first = copy[1]
      local last = copy[#copy]
      table.insert(copy, 1, last)
      table.insert(copy, first)

      local happiness = 0
      for i = 2, #copy - 1 do
        local data = persons[copy[i]]
        happiness = happiness + data[copy[i - 1]] + data[copy[i + 1]]
      end

      max = math.max(max, happiness)
    else
      for i, name in ipairs(current.available) do
        local copy = table.deepcopy(current)
        table.remove(copy.available, i)
        table.insert(copy.seating, name)
        table.insert(queue, copy)
      end
    end
  end

  return max
end

function M:solve1()
  return self:solver(self.input)
end

function M:solve2()
  local persons = self.input
  local kibadda = {}
  for name in pairs(persons) do
    persons[name].Kibadda = 0
    kibadda[name] = 0
  end
  persons.Kibadda = kibadda
  return self:solver(persons)
end

M:run()
