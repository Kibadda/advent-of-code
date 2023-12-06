local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "21")

function M:parse(file)
  for line in file:lines() do
    local split = line:split()
    self.input[split[1]:sub(1, #split[1] - 1)] = {}

    local name = split[1]:sub(1, #split[1] - 1)

    if #split == 2 then
      self.input[name] = tonumber(split[2])
    else
      self.input[name] = {
        one = split[2],
        operation = split[3],
        two = split[4],
      }
    end
  end
end

local function evaluate(monkeys, monkey)
  if type(monkey) == "table" then
    local one = evaluate(monkeys, monkeys[monkey.one])
    local two = evaluate(monkeys, monkeys[monkey.two])

    if monkey.operation == "+" then
      return one + two
    elseif monkey.operation == "-" then
      return one - two
    elseif monkey.operation == "*" then
      return one * two
    elseif monkey.operation == "/" then
      return one / two
    end
  else
    return monkey
  end
end

function M:solve1()
  local monkeys = table.deepcopy(self.input)

  self.solution:add("1", evaluate(monkeys, monkeys.root))
end

local function check_for_humn(monkeys, monkey)
  if type(monkey) == "table" then
    return monkey.one == "humn"
      or monkey.two == "humn"
      or check_for_humn(monkeys, monkeys[monkey.one])
      or check_for_humn(monkeys, monkeys[monkey.two])
  else
    return false
  end
end

local function evaluate2(monkeys, monkey, result)
  if type(monkey) == "table" then
    local number
    local next
    if check_for_humn(monkeys, monkey.one) then
      number = evaluate(monkeys, monkeys[monkey.two])
      next = monkey.one
    else
      number = evaluate(monkeys, monkeys[monkey.one])
      next = monkey.two
    end

    if monkey.operation == "+" then
      return next == "humn" and result - number or evaluate2(monkeys, monkeys[next], result - number)
    elseif monkey.operation == "-" then
      return next == "humn" and result + number or evaluate2(monkeys, monkeys[next], result + number)
    elseif monkey.operation == "*" then
      return next == "humn" and result / number or evaluate2(monkeys, monkeys[next], result / number)
    elseif monkey.operation == "/" then
      return next == "humn" and result * number or evaluate2(monkeys, monkeys[next], result * number)
    end
  else
    return monkey
  end
end

function M:solve2()
  local monkeys = table.deepcopy(self.input)

  local root_monkey = monkeys.root

  local number
  local next
  if check_for_humn(monkeys, monkeys[root_monkey.one]) then
    number = evaluate(monkeys, monkeys[root_monkey.two])
    next = root_monkey.one
  else
    number = evaluate(monkeys, monkeys[root_monkey.one])
    next = root_monkey.two
  end

  self.solution:add("2", evaluate2(monkeys, monkeys[next], number))
end

M:run()

return M
