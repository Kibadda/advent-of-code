--- @class AOCDay202308: AOCDay
--- @field input { directions: ("L"|"R")[], nodes: table<string, { L: string, R: string }> }
local M = require("advent-of-code.AOCDay"):new("2023", "08")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    directions = lines[1]:to_list(),
    nodes = {},
  }

  for i = 3, #lines do
    self.input.nodes[lines[i]:sub(1, 3)] = { L = lines[i]:sub(8, 10), R = lines[i]:sub(13, 15) }
  end
end

--- @param start string
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
    return math.lcm(total, count)
  end)
end

M:run()
