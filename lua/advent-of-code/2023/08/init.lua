local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay202308: AOCDay
---@field input { directions: ("L"|"R")[], nodes: table<string, { L: string, R: string }> }
local M = AOC.create("2023", "08")

---@param file file*
function M:parse(file)
  self.input.directions = file:read():to_list()

  self.input.nodes = {}
  for line in file:lines() do
    self.input.nodes[line:sub(1, 3)] = { L = line:sub(8, 10), R = line:sub(13, 15) }
  end
end

---@param start string
function M:solver(start)
  local current = start

  local count = 0

  for _, dir in cycle(self.input.directions) do
    if current:sub(-1) == "Z" then
      return count
    end

    current = self.input.nodes[current][dir]
    count = count + 1
  end
end

function M:solve1()
  return self:solver "AAA"
end

function M:solve2()
  local starts = table.reduce(self.input.nodes, {}, function(starts, _, name)
    if name:sub(-1) == "A" then
      table.insert(starts, name)
    end

    return starts
  end, pairs)

  local counts = table.map(starts, function(name)
    return self:solver(name)
  end)

  return table.reduce(counts, counts[1], function(total, count)
    return lcm(total, count)
  end)
end

M:run()

return M
