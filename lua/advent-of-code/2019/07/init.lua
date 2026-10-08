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
        :on_input(function()
          return { phases[i], result }
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
      amplifiers[turn] = amplifiers[turn]
        or Intcoder(self.input.program):on_input(function(intcoder)
          if not intcoder.data.setup then
            intcoder.data.setup = true

            if turn == 1 then
              return { phases[turn] + 5, 0 }
            else
              local input = { phases[turn] + 5, unpack(amplifiers[turn - 1].output) }
              amplifiers[turn - 1].output = {}

              return input
            end
          else
            local last = turn == 1 and 5 or turn - 1

            if not amplifiers[last] then
              return {}
            end

            local input = { unpack(amplifiers[last].output) }
            amplifiers[last].output = {}

            return input
          end
        end):run()
      amplifiers[turn]:run()

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
