--- @class AOCDay201816: AOCDay
--- @field input { samples: { before: integer[], instruction: integer[], after: integer[] }[], program: integer[][] }
local M = require("advent-of-code.AOCDay"):new("2018", "16")

--- @param lines string[]
function M:parse(lines)
  local maybe_parse_program = false
  local parse_program = false

  self.input = {
    samples = {},
    program = {},
  }

  local sample = {
    before = nil,
    instruction = nil,
    after = nil,
  }

  for _, line in ipairs(lines) do
    if line == "" then
      if maybe_parse_program then
        parse_program = true
      else
        maybe_parse_program = true
        table.insert(self.input.samples, sample)
        sample = {}
      end
    elseif parse_program then
      table.insert(self.input.program, line:only_ints())
    else
      maybe_parse_program = false
      if not sample.before then
        sample.before = line:only_ints()
      elseif not sample.instruction then
        sample.instruction = line:only_ints()
      else
        sample.after = line:only_ints()
      end
    end
  end
end

local OP_CODES = {
  addr = function(instruction, registers)
    registers[instruction[4] + 1] = registers[instruction[2] + 1] + registers[instruction[3] + 1]
  end,
  addi = function(instruction, registers)
    registers[instruction[4] + 1] = registers[instruction[2] + 1] + instruction[3]
  end,

  mulr = function(instruction, registers)
    registers[instruction[4] + 1] = registers[instruction[2] + 1] * registers[instruction[3] + 1]
  end,
  muli = function(instruction, registers)
    registers[instruction[4] + 1] = registers[instruction[2] + 1] * instruction[3]
  end,

  banr = function(instruction, registers)
    registers[instruction[4] + 1] = bit.band(registers[instruction[2] + 1], registers[instruction[3] + 1])
  end,
  bani = function(instruction, registers)
    registers[instruction[4] + 1] = bit.band(registers[instruction[2] + 1], instruction[3])
  end,

  borr = function(instruction, registers)
    registers[instruction[4] + 1] = bit.bor(registers[instruction[2] + 1], registers[instruction[3] + 1])
  end,
  bori = function(instruction, registers)
    registers[instruction[4] + 1] = bit.bor(registers[instruction[2] + 1], instruction[3])
  end,

  setr = function(instruction, registers)
    registers[instruction[4] + 1] = registers[instruction[2] + 1]
  end,
  seti = function(instruction, registers)
    registers[instruction[4] + 1] = instruction[2]
  end,

  gtir = function(instruction, registers)
    registers[instruction[4] + 1] = instruction[2] > registers[instruction[3] + 1] and 1 or 0
  end,
  gtri = function(instruction, registers)
    registers[instruction[4] + 1] = registers[instruction[2] + 1] > instruction[3] and 1 or 0
  end,
  gtrr = function(instruction, registers)
    registers[instruction[4] + 1] = registers[instruction[2] + 1] > registers[instruction[3] + 1] and 1 or 0
  end,

  eqir = function(instruction, registers)
    registers[instruction[4] + 1] = instruction[2] == registers[instruction[3] + 1] and 1 or 0
  end,
  eqri = function(instruction, registers)
    registers[instruction[4] + 1] = registers[instruction[2] + 1] == instruction[3] and 1 or 0
  end,
  eqrr = function(instruction, registers)
    registers[instruction[4] + 1] = registers[instruction[2] + 1] == registers[instruction[3] + 1] and 1 or 0
  end,
}

function M:solve1()
  local function test(ra, rb)
    return ra[1] == rb[1] and ra[2] == rb[2] and ra[3] == rb[3] and ra[4] == rb[4]
  end

  return table.reduce(self.input.samples, 0, function(threes, sample)
    local tests = 0

    for _, func in pairs(OP_CODES) do
      local before = table.deepcopy(sample.before)
      func(sample.instruction, before)

      if test(before, sample.after) then
        tests = tests + 1
      end

      if tests >= 3 then
        return threes + 1
      end
    end

    return threes
  end)
end

function M:solve2()
  local lookup = {}
  local mapping = {}

  while table.count(mapping) ~= table.count(OP_CODES) do
    local function test(ra, rb)
      return ra[1] == rb[1] and ra[2] == rb[2] and ra[3] == rb[3] and ra[4] == rb[4]
    end

    for _, sample in ipairs(self.input.samples) do
      if not mapping[sample.instruction[1]] then
        local same = 0
        local op_code, op_name

        for name, func in pairs(OP_CODES) do
          if not lookup[name] then
            local before = table.deepcopy(sample.before)
            func(sample.instruction, before)

            if test(before, sample.after) then
              same = same + 1
              op_code = sample.instruction[1]
              op_name = name
            end
          end
        end

        if same == 1 then
          lookup[op_name] = op_code
          mapping[op_code] = op_name
          op_name = nil
          op_code = nil
        end
      end
    end
  end

  local registers = table.reduce(self.input.program, { 0, 0, 0, 0 }, function(regs, instruction)
    OP_CODES[mapping[instruction[1]]](instruction, regs)
    return regs
  end)

  return registers[1]
end

M:run()
