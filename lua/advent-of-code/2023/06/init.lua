local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay202306: AOCDay
---@field input { times: integer[], records: integer[] }
local M = AOC.create("2023", "06")

function M:parse(file)
  for line in file:lines() do
    if not self.input.times then
      self.input.times = line:only_ints()
    else
      self.input.records = line:only_ints()
    end
  end
end

---@param time integer
---@param record integer
function M:solver(time, record)
  return table.reduce(table.range(time, 0), 0, function(count, i)
    return count + (i * (time - i) > record and 1 or 0)
  end)
end

function M:solve1()
  return table.reduce(self.input.times, 1, function(margin, time, i)
    return margin * self:solver(time, self.input.records[i])
  end)
end

function M:solve2()
  return self:solver(tonumber(table.concat(self.input.times)) or 0, tonumber(table.concat(self.input.records)) or 0)
end

M:run()

return M
