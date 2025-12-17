--- @class AOCDay201512: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2015", "12")

function M:solve1()
  return table.reduce(self.input:only_ints "-?%d+", 0, function(carry, num)
    return carry + num
  end)
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
  return sum(JSON.parse(self.input))
end

M:run()
