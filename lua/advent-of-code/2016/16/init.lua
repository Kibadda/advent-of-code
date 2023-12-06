local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "16")

function M:parse(file)
  for line in file:lines() do
    self.input = line
  end
end

function M:solver(length)
  ---@type string
  local result = self.input
  while #result < length do
    result = result
      .. "0"
      .. table.concat(table.map(result:reverse():to_list(), function(bin)
        return bin == "1" and "0" or "1"
      end))
  end
  local checksum = result:sub(1, length)
  while #checksum % 2 == 0 do
    checksum = table.concat(table.map(checksum:to_chunks(2), function(chunk)
      if chunk == "11" or chunk == "00" then
        return "1"
      else
        return "0"
      end
    end))
  end

  return checksum
end

function M:solve1()
  self.solution:add("1", self:solver(self.test and 20 or 272))
end

function M:solve2()
  self.solution:add("2", self:solver(self.test and 20 or 35651584))
end

M:run()

return M
