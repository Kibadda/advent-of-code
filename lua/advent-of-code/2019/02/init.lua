--- @class AOCDay201902: AOCDay
--- @field input integer[]
local M = require("advent-of-code.AOCDay"):new("2019", "02")

--- @param lines string[]
function M:parse(lines)
  self.input = lines[1]:only_ints()
end

function M:solver(noun, verb)
  local pointer = 1
  local program = table.deepcopy(self.input)

  program[2] = noun
  program[3] = verb

  local opcodes = {
    [1] = function()
      program[program[pointer + 3] + 1] = program[program[pointer + 1] + 1] + program[program[pointer + 2] + 1]
    end,
    [2] = function()
      program[program[pointer + 3] + 1] = program[program[pointer + 1] + 1] * program[program[pointer + 2] + 1]
    end,
  }

  while true do
    local opcode = program[pointer]

    if not opcode or opcode == 99 or not opcodes[opcode] then
      break
    end

    opcodes[opcode]()

    pointer = pointer + 4
  end

  return program[1]
end

function M:solve1()
  return self:solver(12, 2)
end

function M:solve2()
  for noun = 0, 99 do
    for verb = 0, 99 do
      if self:solver(noun, verb) == 19690720 then
        return 100 * noun + verb
      end
    end
  end
end

M:run()
