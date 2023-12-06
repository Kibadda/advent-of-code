local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "15")

function M:parse(file)
  for line in file:lines() do
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
  self.solution:add("1", self:solver(self.input))
end

function M:solve2()
  self.input[#self.input + 1] = { max_pos = 11, current_pos = 0 }
  self.solution:add("2", self:solver(self.input))
end

M:run()

return M
