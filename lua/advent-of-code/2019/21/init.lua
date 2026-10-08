--- @class AOCDay201921: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "21")

require "advent-of-code.2019.intcoder"

function M:solver(program)
  return table.remove(Intcoder(self.input[1])
    :on_input(function()
      return program
    end)
    :run({
      ascii = true,
    }).output)
end

function M:solve1()
  return self:solver {
    "NOT B J",
    "NOT C T",
    "OR T J",
    "AND D J",
    "NOT A T",
    "OR T J",
    "WALK",
  }
end

function M:solve2()
  return self:solver {
    "NOT B J",
    "NOT C T",
    "OR T J",
    "AND D J",
    "AND H J",
    "NOT A T",
    "OR T J",
    "RUN",
  }
end

M:run()
