local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "23")

function M:parse_input(file)
  for line in file:lines() do
    local split = line:split()
    table.insert(self.input, {
      cmd = split[1],
      x = tonumber(split[2]) or split[2],
      y = tonumber(split[3]) or split[3],
    })
  end
end

function M:solver(registers)
  local instructions = table.deepcopy(self.input)
  local i = 1
  while true do
    local instruction = instructions[i]

    if not instruction then
      break
    end

    match(instruction.cmd) {
      cpy = function()
        if type(instruction.y) == "string" then
          if type(instruction.x) == "number" then
            registers[instruction.y] = instruction.x
          else
            registers[instruction.y] = registers[instruction.x]
          end
        end
      end,
      inc = function()
        registers[instruction.x] = registers[instruction.x] + 1
      end,
      dec = function()
        registers[instruction.x] = registers[instruction.x] - 1
      end,
      jnz = function()
        if registers[instruction.x] ~= 0 then
          i = i + ((type(instruction.y) == "number" and instruction.y or registers[instruction.y]) - 1)
        end
      end,
      tgl = function()
        local j = i + (type(instruction.x) == "number" and instruction.x or registers[instruction.x])
        if instructions[j] then
          if instructions[j].y then
            instructions[j].cmd = match(instructions[j].cmd) {
              jnz = "cpy",
              _ = "jnz",
            }
          else
            instructions[j].cmd = match(instructions[j].cmd) {
              inc = "dec",
              _ = "inc",
            }
          end
        end
      end,
    }

    i = i + 1
  end

  return registers
end

function M:solve1(registers)
  self.solution:add("1", self:solver(registers).a)
end

function M:solve2(registers)
  self.solution:add("2", self:solver(registers).a)
end

M:run(false, { { a = 0 }, { a = 7, b = 0, c = 0, d = 0 } }, { { a = 0 }, { a = 12, b = 0, c = 0, d = 0 } })

return M
