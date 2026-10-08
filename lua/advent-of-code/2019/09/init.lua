--- @class AOCDay201909: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "09")

require "advent-of-code.2019.intcoder"

function M:solver(mode)
  return Intcoder(self.input[1])
    :on_input(function()
      return { mode }
    end)
    :run().output[1]
end

function M:solve1()
  return self:solver(1)
end

function M:solve2()
  return self:solver(2)
end

M:run()
