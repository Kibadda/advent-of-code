--- @class AOCDay201905: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "05")

require "advent-of-code.2019.intcoder"

function M:solve1()
  return table.remove(Intcoder(self.input[1]):active({ 1, 2, 3, 4 }):run().output)
end

function M:solve2()
  return table.remove(Intcoder(self.input[1]):active({ 1, 2, 3, 4, 5, 6, 7, 8 }):run().output)
end

M:run()
