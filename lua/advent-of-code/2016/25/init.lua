--- @class AOCDay201625: AOCDay
--- @field input { cmd: string, x: string|number, y: string|number }[]
local M = require("advent-of-code.AOC").create("2016", "25")

--- @param file file*
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

function M:solve1()
  local a = -1

  while true do
    a = a + 1

    local instructions = table.deepcopy(self.input)

    local registers = { a = a }
    local output = {}
    local wrong_output = false
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
          if (type(instruction.x) == "number" and instruction.x or registers[instruction.x]) ~= 0 then
            i = i + ((type(instruction.y) == "number" and instruction.y or registers[instruction.y]) - 1)
          end
        end,
        out = function()
          local out = (type(instruction.x) == "number" and instruction.x or registers[instruction.x])
          if (#output > 0 and output[#output] == out) or (out ~= 0 and out ~= 1) then
            wrong_output = true
          end
          table.insert(output, out)
        end,
      }

      i = i + 1

      if wrong_output then
        break
      end

      if #output > 100 then
        return a
      end
    end
  end
end

function M:solve2() end

M:run()
