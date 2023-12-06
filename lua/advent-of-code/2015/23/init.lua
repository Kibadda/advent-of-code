local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "23")

function M:parse(file)
  self.input = {
    registers = {
      a = 0,
      b = 0,
    },
    instructions = {},
  }
  for line in file:lines() do
    local split = line:gsub(",", ""):split()
    if #split == 2 then
      if split[1] == "jmp" then
        table.insert(self.input.instructions, {
          instruction = split[1],
          offset = tonumber(split[2]),
        })
      else
        table.insert(self.input.instructions, {
          instruction = split[1],
          register = split[2],
        })
      end
    else
      table.insert(self.input.instructions, {
        instruction = split[1],
        register = split[2],
        offset = tonumber(split[3]),
      })
    end
  end
end

function M:solver(registers)
  local index = 1
  while true do
    local instruction = self.input.instructions[index]
    if instruction == nil then
      break
    end

    match(instruction.instruction) {
      ["inc"] = function()
        registers[instruction.register] = registers[instruction.register] + 1
      end,
      ["hlf"] = function()
        registers[instruction.register] = math.floor(registers[instruction.register] / 2)
      end,
      ["tpl"] = function()
        registers[instruction.register] = registers[instruction.register] * 3
      end,
      ["jmp"] = function()
        index = index + instruction.offset - 1
      end,
      ["jie"] = function()
        if registers[instruction.register] % 2 == 0 then
          index = index + instruction.offset - 1
        end
      end,
      ["jio"] = function()
        if registers[instruction.register] == 1 then
          index = index + instruction.offset - 1
        end
      end,
    }

    index = index + 1
  end

  return registers
end

function M:solve1()
  self.solution:add("1", self:solver({ a = 0, b = 0 }).b)
end

function M:solve2()
  self.solution:add("2", self:solver({ a = 1, b = 0 }).b)
end

M:run()

return M
