--- @class AOCDay201902: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "02")

require "advent-of-code.2019.intcoder"

function M:solve1()
  return Intcoder(self.input[1])
    :active({ 1, 2 })
    :setup(function(intcoder)
      intcoder.program[2] = 12
      intcoder.program[3] = 2
    end)
    :run().program[1]
end

function M:solve2()
  for noun = 0, 99 do
    for verb = 0, 99 do
      if
        Intcoder(self.input[1])
          :active({ 1, 2 })
          :setup(function(intcoder)
            intcoder.program[2] = noun
            intcoder.program[3] = verb
          end)
          :run().program[1] == 19690720
      then
        return 100 * noun + verb
      end
    end
  end
end

M:run()
