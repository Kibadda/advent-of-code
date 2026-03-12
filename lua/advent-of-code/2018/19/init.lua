--- @class AOCDay201819: AOCDay
--- @field input { pointer: integer, instructions: { operation: string, instruction: integer[] }[] }
local M = require("advent-of-code.AOCDay"):new("2018", "19")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    instructions = {},
  }

  for _, line in ipairs(lines) do
    if not self.input.pointer then
      self.input.pointer = line:only_ints()[1] + 1
    else
      table.insert(self.input.instructions, { line:match "^([%S]+)", unpack(line:only_ints()) })
    end
  end
end

function M:solver(value)
  local registers = Program {
    registers = { value, 0, 0, 0, 0, 0 },
    hooks = {
      pre = function(p)
        p.registers[self.input.pointer] = p.pointer - 1
      end,
      post = function(p)
        p.pointer = p.registers[self.input.pointer] + 1
      end,
    },
    operations = {
      addr = function(p, instruction)
        p.registers[instruction[4] + 1] = p.registers[instruction[2] + 1] + p.registers[instruction[3] + 1]
      end,
      addi = function(p, instruction)
        p.registers[instruction[4] + 1] = p.registers[instruction[2] + 1] + instruction[3]
      end,

      mulr = function(p, instruction)
        p.registers[instruction[4] + 1] = p.registers[instruction[2] + 1] * p.registers[instruction[3] + 1]
      end,
      muli = function(p, instruction)
        p.registers[instruction[4] + 1] = p.registers[instruction[2] + 1] * instruction[3]
      end,

      banr = function(p, instruction)
        p.registers[instruction[4] + 1] = bit.band(p.registers[instruction[2] + 1], p.registers[instruction[3] + 1])
      end,
      bani = function(p, instruction)
        p.registers[instruction[4] + 1] = bit.band(p.registers[instruction[2] + 1], instruction[3])
      end,

      borr = function(p, instruction)
        p.registers[instruction[4] + 1] = bit.bor(p.registers[instruction[2] + 1], p.registers[instruction[3] + 1])
      end,
      bori = function(p, instruction)
        p.registers[instruction[4] + 1] = bit.bor(p.registers[instruction[2] + 1], instruction[3])
      end,

      setr = function(p, instruction)
        p.registers[instruction[4] + 1] = p.registers[instruction[2] + 1]
      end,
      seti = function(p, instruction)
        p.registers[instruction[4] + 1] = instruction[2]
      end,

      gtir = function(p, instruction)
        p.registers[instruction[4] + 1] = instruction[2] > p.registers[instruction[3] + 1] and 1 or 0
      end,
      gtri = function(p, instruction)
        p.registers[instruction[4] + 1] = p.registers[instruction[2] + 1] > instruction[3] and 1 or 0
      end,
      gtrr = function(p, instruction)
        p.registers[instruction[4] + 1] = p.registers[instruction[2] + 1] > p.registers[instruction[3] + 1] and 1 or 0
      end,

      eqir = function(p, instruction)
        p.registers[instruction[4] + 1] = instruction[2] == p.registers[instruction[3] + 1] and 1 or 0
      end,
      eqri = function(p, instruction)
        p.registers[instruction[4] + 1] = p.registers[instruction[2] + 1] == instruction[3] and 1 or 0
      end,
      eqrr = function(p, instruction)
        p.registers[instruction[4] + 1] = p.registers[instruction[2] + 1] == p.registers[instruction[3] + 1] and 1 or 0
      end,
    },
    instructions = self.input.instructions,
  }

  return registers[1]
end

function M:solve1()
  return self:solver(0)
end

function M:solve2()
  return self:solver(1)
end

M:run()
