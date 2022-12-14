local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "11")

function M:parse_input(file)
  local monkey = { inspections = 0 }
  for line in file:lines() do
    if line == "" then
      table.insert(self.input, monkey)
      monkey = { inspections = 0 }
    else
      local split = line:split ":"
      if split[1] == "  Starting items" then
        monkey.items = split[2]:split ", "
      elseif split[1] == "  Operation" then
        monkey.operation = split[2]
      elseif split[1] == "  Test" then
        monkey.test = tonumber(split[2]:split()[3])
      elseif split[1] == "    If true" then
        monkey.if_true = tonumber(split[2]:split()[4]) + 1
      elseif split[1] == "    If false" then
        monkey.if_false = tonumber(split[2]:split()[4]) + 1
      end
    end
  end
end

function M:solve1()
  local monkeys = table.deepcopy(self.input)

  for _ = 1, 20 do
    for _, monkey in ipairs(monkeys) do
      for _, item in ipairs(monkey.items) do
        local op = ("local%s; return new"):format(monkey.operation):gsub("old", item)
        local new = math.floor(loadstring(op)() / 3)

        local index = new % monkey.test == 0 and monkey.if_true or monkey.if_false
        table.insert(monkeys[index].items, new)
      end
      monkey.inspections = monkey.inspections + #monkey.items
      monkey.items = {}
    end
  end

  local max1, max2 = 0, 0
  for _, monkey in ipairs(monkeys) do
    if monkey.inspections > max1 then
      if monkey.inspections > max2 then
        max1, max2 = max2, monkey.inspections
      else
        max1, max2 = monkey.inspections, max2
      end
    end
  end

  self.solution:add("1", max1 * max2)
end

function M:solve2()
  local monkeys = table.deepcopy(self.input)

  for _ = 1, 10000 do
    for _, monkey in ipairs(monkeys) do
      for _, item in ipairs(monkey.items) do
        local op = ("local%s; return new"):format(monkey.operation):gsub("old", item)
        local new = loadstring(op)() % 9699690

        local index = new % monkey.test == 0 and monkey.if_true or monkey.if_false
        table.insert(monkeys[index].items, new)
      end
      monkey.inspections = monkey.inspections + #monkey.items
      monkey.items = {}
    end
  end

  local max1, max2 = 0, 0
  for _, monkey in ipairs(monkeys) do
    if monkey.inspections > max1 then
      if monkey.inspections > max2 then
        max1, max2 = max2, monkey.inspections
      else
        max1, max2 = monkey.inspections, max2
      end
    end
  end

  self.solution:add("2", max1 * max2)
end

M:run(false)

return M
