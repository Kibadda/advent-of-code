local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "08")

function M:parse_input(file)
  self.input = {}
  for line in file:lines() do
    local split = line:split()

    self.input[#self.input + 1] = {
      register = split[1],
      offset = (split[2] == "inc" and 1 or -1) * tonumber(split[3]),
      check = function(registers)
        registers[split[5]] = registers[split[5]] or 0

        return match(split[6]) {
          ["<"] = registers[split[5]] < tonumber(split[7]),
          [">"] = registers[split[5]] > tonumber(split[7]),
          ["<="] = registers[split[5]] <= tonumber(split[7]),
          [">="] = registers[split[5]] >= tonumber(split[7]),
          ["=="] = registers[split[5]] == tonumber(split[7]),
          ["!="] = registers[split[5]] ~= tonumber(split[7]),
        }
      end,
    }
  end
end

function M:solve1()
  local registers = {}
  for _, instruction in ipairs(self.input) do
    if instruction.check(registers) then
      registers[instruction.register] = (registers[instruction.register] or 0) + instruction.offset
    end
  end
  self.solution:add(
    "1",
    table.reduce(registers, -math.huge, function(carry, register)
      return math.max(carry, register)
    end, pairs)
  )
end

function M:solve2()
  local registers = {}
  local max = -math.huge
  for _, instruction in ipairs(self.input) do
    if instruction.check(registers) then
      registers[instruction.register] = (registers[instruction.register] or 0) + instruction.offset
      max = math.max(max, registers[instruction.register])
    end
  end
  self.solution:add("2", max)
end

M:run(false)

return M
