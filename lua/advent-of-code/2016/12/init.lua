local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "12")

function M:parse(file)
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
  local i = 1
  while true do
    local instruction = self.input[i]

    if not instruction then
      break
    end

    match(instruction.cmd) {
      cpy = function()
        if type(instruction.x) == "number" then
          registers[instruction.y] = instruction.x
        else
          registers[instruction.y] = registers[instruction.x]
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
          i = i + (instruction.y - 1)
        end
      end,
    }

    i = i + 1
  end

  return registers
end

function M:solve1()
  self.solution:add("1", self:solver({ a = 0, b = 0, c = 0, d = 0 }).a)
end

function M:solve2()
  self.solution:add("2", self:solver({ a = 0, b = 0, c = 1, d = 0 }).a)
end

M:run()

return M
