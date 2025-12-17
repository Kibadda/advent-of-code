--- @class AOCDay201705: AOCDay
--- @field input number[]
local M = require("advent-of-code.AOCDay"):new("2017", "05")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, tonumber(line))
  end
end

function M:solver(fun)
  local jumps = table.deepcopy(self.input)
  local index = 1
  local steps = 0
  while jumps[index] do
    local new = index + jumps[index]
    jumps[index] = fun(jumps[index])
    index = new
    steps = steps + 1
  end
  return steps
end

function M:solve1()
  return self:solver(function(jump)
    return jump + 1
  end)
end

function M:solve2()
  return self:solver(function(jump)
    return jump >= 3 and jump - 1 or jump + 1
  end)
end

M:run()
