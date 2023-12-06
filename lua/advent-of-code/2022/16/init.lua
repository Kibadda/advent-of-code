local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "16")

function M:parse(file)
  self.input = {
    names = {},
    flows = {},
    conns = {},
    dist = {},
  }

  for line in file:lines() do
    local split = line:gsub(";", ""):gsub(",", ""):split()
    table.insert(self.input.names, split[2])
    table.insert(self.input.flows, tonumber(split[5]:split("=")[2]))

    local connections = {}
    for i = 10, #split do
      table.insert(connections, split[i])
    end

    table.insert(self.input.conns, connections)
  end

  self.input.flows = table.filter(self.input.flows, function(flow)
    return flow > 0
  end)

  for i = 1, #self.input.names do
    self.input.dist[i] = self.input.dist[i] or {}
    for j = 1, #self.input.names do
      self.input.dist[i][j] = math.huge
    end
  end

  for i, connections in ipairs(self.input.conns) do
    for _, conn in ipairs(connections) do
      self.input.dist[i][table.find(self.input.names, conn)] = 1
    end
  end

  for i = 1, #self.input.names do
    for j = 1, #self.input.names do
      for k = 1, #self.input.names do
        self.input.dist[j][k] = math.min(self.input.dist[j][k], self.input.dist[j][i] + self.input.dist[i][k])
      end
    end
  end

  self.input.start = table.find(self.input.names, "AA")
end

function M:solver(puzzle, current, rest, time)
  local max = puzzle == 1 and 0 or self:solver(1, self.input.start, rest, 26)

  for i in pairs(rest) do
    if self.input.dist[current][i] < time then
      local rflows = table.deepcopy(rest)
      rflows[i] = nil
      local rtime = time - self.input.dist[current][i] - 1
      max = math.max(max, self.input.flows[i] * rtime + self:solver(puzzle, i, rflows, rtime))
    end
  end

  return max
end

function M:solve1()
  self.solution:add("1", self:solver(1, self.input.start, self.input.flows, 30))
end

function M:solve2()
  self.solution:add("2", self:solver(2, self.input.start, self.input.flows, 26))
end

M:run()

return M
