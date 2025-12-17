--- @class AOCDay202201: AOCDay
--- @field input number[]
local M = require("advent-of-code.AOCDay"):new("2022", "01")

--- @param lines string[]
function M:parse(lines)
  table.insert(self.input, 0)

  local current_pos = 1
  for _, line in ipairs(lines) do
    local number = tonumber(line)
    if number == nil then
      table.insert(self.input, 0)
      current_pos = current_pos + 1
    else
      self.input[current_pos] = self.input[current_pos] + number
    end
  end

  table.sort(self.input, function(a, b)
    return b < a
  end)
end

function M:solve1()
  return self.input[1]
end

function M:solve2()
  return self.input[1] + self.input[2] + self.input[3]
end

M:run()
