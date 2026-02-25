--- @class AOCDay202407: AOCDay
--- @field input integer[][]
local M = require("advent-of-code.AOCDay"):new("2024", "07")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:only_ints())
  end
end

--- @param extra boolean
function M:solver(extra)
  --- @param value integer
  --- @param remaining integer[]
  --- @return integer[]
  local function operate(value, remaining)
    if #remaining == 0 then
      return { value }
    end

    local next = table.remove(remaining, 1)

    local plus = operate(value + next, table.deepcopy(remaining))
    local mult = operate(value * next, table.deepcopy(remaining))
    local conc = not extra and {}
      or operate(value * math.pow(10, math.floor(math.log10(next)) + 1) + next, table.deepcopy(remaining))

    return table.extend(plus, mult, conc)
  end

  return table.reduce(table.deepcopy(self.input), 0, function(count, numbers)
    local result = table.remove(numbers, 1)
    local results = operate(table.remove(numbers, 1), numbers)

    if table.find(results, result) then
      return count + result
    end

    return count
  end)
end

function M:solve1()
  return self:solver(false)
end

function M:solve2()
  return self:solver(true)
end

M:run()
