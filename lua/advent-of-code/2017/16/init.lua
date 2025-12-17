--- @class AOCDay201716: AOCDay
--- @field input { cmd: string, amount?: integer, pos?: integer[], programs?: string[] }[]
local M = require("advent-of-code.AOCDay"):new("2017", "16")

--- @param lines string[]
function M:parse(lines)
  for _, dance in ipairs(lines[1]:split ",") do
    table.insert(
      self.input,
      match(dance:at(1)) {
        s = { cmd = "s", amount = dance:only_ints()[1] },
        x = { cmd = "x", pos = { dance:only_ints()[1], dance:only_ints()[2] } },
        p = { cmd = "p", programs = { dance:at(2), dance:at(4) } },
      }
    )
  end
end

function M:solver(str)
  for _, instruction in ipairs(self.input) do
    match(instruction.cmd) {
      s = function()
        str = str:sub(#str - instruction.amount + 1) .. str:sub(1, #str - instruction.amount)
      end,
      x = function()
        local min = math.min(instruction.pos[1] + 1, instruction.pos[2] + 1)
        local max = math.max(instruction.pos[1] + 1, instruction.pos[2] + 1)
        str = str:sub(1, min - 1) .. str:at(max) .. str:sub(min + 1, max - 1) .. str:at(min) .. str:sub(max + 1)
      end,
      p = function()
        str = str
          :gsub(instruction.programs[1], "z")
          :gsub(instruction.programs[2], instruction.programs[1])
          :gsub("z", instruction.programs[2])
      end,
    }
  end
  return str
end

function M:solve1()
  local programs = ""
  for i = 1, self.test and 5 or 16 do
    programs = programs .. string.char(96 + i)
  end

  return self:solver(programs)
end

function M:solve2()
  local programs = ""
  for i = 1, self.test and 5 or 16 do
    programs = programs .. string.char(96 + i)
  end

  local look = programs
  local history = { look }
  local i = 0
  while true do
    i = i + 1
    look = self:solver(look)
    if look ~= programs then
      history[#history + 1] = look
    else
      break
    end
  end

  return history[1000000000 % i + 1]
end

M:run()
