local AOC = require "advent-of-code.AOC"
AOC.reload()

local json = require "advent-of-code.helpers.json"

local M = AOC.create("2015", "12")

function M:parse(file)
  for line in file:lines() do
    self.input = line
  end
end

function M:solve1()
  self.solution:add(
    "1",
    table.reduce(self.input:only_ints "-?%d+", 0, function(carry, num)
      return carry + num
    end)
  )
end

function M:solve2()
  local function sum(t)
    local s = 0
    for k, v in pairs(t) do
      if type(v) == "number" then
        s = s + v
      elseif type(v) == "table" then
        s = s + sum(v)
      elseif type(v) == "string" and v == "red" and type(k) == "string" then
        return 0
      end
    end
    return s
  end
  self.solution:add("2", sum(json.parse(self.input)))
end

M:run()

return M
