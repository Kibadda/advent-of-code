--- @class AOCDay201905: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "05")

require "advent-of-code.2019.intcoder"

function M:solve1()
  return table.remove(Intcoder(self.input[1])
    :setup(function(intcoder)
      table.insert(intcoder.input, 1)
    end)
    :run().output)
end

function M:solve2()
  return table.remove(Intcoder(self.input[1])
    :setup(function(intcoder)
      table.insert(intcoder.input, 5)
    end)
    :run().output)
end

M:run()
