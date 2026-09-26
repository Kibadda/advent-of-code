--- @class AOCDay201907: AOCDay
--- @field input { program: string, phases: integer[][] }
local M = require("advent-of-code.AOCDay"):new("2019", "07")

require "advent-of-code.2019.intcoder"

--- @param lines string[]
function M:parse(lines)
  self.input = {
    program = lines[1],
    phases = {},
  }

  for i = 1, 5 do
    for j = 1, 4 do
      for k = 1, 3 do
        for l = 1, 2 do
          local phases = { 0, 1, 2, 3, 4 }

          local a_phase = table.remove(phases, i)
          local b_phase = table.remove(phases, j)
          local c_phase = table.remove(phases, k)
          local d_phase = table.remove(phases, l)
          local e_phase = table.remove(phases)

          table.insert(self.input.phases, { a_phase, b_phase, c_phase, d_phase, e_phase })
        end
      end
    end
  end
end

function M:solve1()
  local max = -math.huge

  for _, phases in ipairs(self.input.phases) do
    local result = 0

    for i = 1, 5 do
      result = Intcoder(self.input.program)
        :setup(function(intcoder)
          table.insert(intcoder.input, phases[i])
          table.insert(intcoder.input, result)
        end)
        :run().output[1]
    end

    max = math.max(max, result)
  end

  return max
end

function M:solve2()
  local max = -math.huge

  for _, phases in ipairs(self.input.phases) do
    local turn = 1
    --- @type Intcoder[]
    local amplifiers = {}
    while true do
      if not amplifiers[turn] then
        amplifiers[turn] = Intcoder(self.input.program):setup(function(intcoder)
          intcoder.opcodes[3].func = function(_, parameters)
            if #intcoder.input > 0 then
              if not intcoder.input[1] then
                return IntcoderOpcodesReturnCode.ERROR
              end

              intcoder.program[parameters[1] + 1] = table.remove(intcoder.input, 1)
            else
              return IntcoderOpcodesReturnCode.BREAK
            end
          end

          if turn == 1 then
            intcoder.input = { phases[turn] + 5, 0 }
          else
            intcoder.input = { phases[turn] + 5, unpack(amplifiers[turn - 1].output) }
            amplifiers[turn - 1].output = {}
          end
        end):run()
      else
        amplifiers[turn]
          :setup(function(intcoder)
            local last = turn == 1 and 5 or turn - 1
            intcoder.input = { unpack(amplifiers[last].output) }
            amplifiers[last].output = {}
          end)
          :run()
      end

      if turn == 5 and amplifiers[5].exit == IntcoderExitStatus.OK then
        break
      end

      if turn == 5 then
        turn = 1
      else
        turn = turn + 1
      end
    end

    max = math.max(max, amplifiers[5].output[1])
  end

  return max
end

M:run()
