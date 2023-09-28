local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "18")

function M:solver(length)
  local rows = table.deepcopy(self.input)
  while #rows < length do
    local new_row = {}
    local last_row = rows[#rows]:to_list()
    for i = 1, #last_row do
      local left = last_row[i - 1] or "."
      local center = last_row[i]
      local right = last_row[i + 1] or "."

      if
        (left == "^" and center == "^" and right == ".")
        or (left == "." and center == "^" and right == "^")
        or (left == "^" and center == "." and right == ".")
        or (left == "." and center == "." and right == "^")
      then
        new_row[i] = "^"
      else
        new_row[i] = "."
      end
    end
    rows[#rows + 1] = table.concat(new_row)
  end
  local traps = 0
  for _, row in ipairs(rows) do
    local _, count = row:gsub("%.", "^")
    traps = traps + count
  end
  return traps
end

function M:solve1()
  self.solution:add("1", self:solver(self.test and 10 or 40))
end

function M:solve2()
  self.solution:add("2", self:solver(self.test and 10 or 400000))
end

M:run()

return M
