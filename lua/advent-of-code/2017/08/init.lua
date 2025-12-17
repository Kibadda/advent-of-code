--- @class AOCDay201708: AOCDay
--- @field input { register: string, offset: number, check: function }[]
local M = require("advent-of-code.AOCDay"):new("2017", "08")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local split = line:split()

    table.insert(self.input, {
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
    })
  end
end

function M:solve1()
  local registers = {}
  for _, instruction in ipairs(self.input) do
    if instruction.check(registers) then
      registers[instruction.register] = (registers[instruction.register] or 0) + instruction.offset
    end
  end
  return table.reduce(registers, -math.huge, function(carry, register)
    return math.max(carry, register)
  end, pairs)
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
  return max
end

M:run()
