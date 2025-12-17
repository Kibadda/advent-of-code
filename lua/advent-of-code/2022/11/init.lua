--- @class AOCDay202211: AOCDay
--- @field input { inspections: integer, items: string[], operation: string, test: integer, if_true: integer, if_false: integer }[]
local M = require("advent-of-code.AOCDay"):new("2022", "11")

--- @param lines string[]
function M:parse(lines)
  local monkey = { inspections = 0 }
  for _, line in ipairs(lines) do
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

function M:solver(rounds, fun)
  local monkeys = table.deepcopy(self.input)

  for _ = 1, rounds do
    for _, monkey in ipairs(monkeys) do
      for _, item in ipairs(monkey.items) do
        local op = ("local%s; return new"):format(monkey.operation):gsub("old", item)
        local new = fun(op)

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

  return max1 * max2
end

function M:solve1()
  return self:solver(20, function(op)
    return math.floor(loadstring(op)() / 3)
  end)
end

function M:solve2()
  return self:solver(10000, function(op)
    return loadstring(op)() % 9699690
  end)
end

M:run()
