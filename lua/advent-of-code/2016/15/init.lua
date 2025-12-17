--- @class AOCDay201615: AOCDay
--- @field input { max_pos: integer, current_pos: integer }[]
local M = require("advent-of-code.AOCDay"):new("2016", "15")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local ints = line:only_ints()
    table.insert(self.input, {
      max_pos = ints[2],
      current_pos = ints[4],
    })
  end
end

function M:solver(discs)
  local time = 0
  while true do
    local falls_through = true
    for i, disc in ipairs(discs) do
      if (time + i + disc.current_pos) % disc.max_pos ~= 0 then
        falls_through = false
        break
      end
    end
    if falls_through then
      break
    end
    time = time + 1
  end
  return time
end

function M:solve1()
  return self:solver(self.input)
end

function M:solve2()
  self.input[#self.input + 1] = { max_pos = 11, current_pos = 0 }
  return self:solver(self.input)
end

M:run()
