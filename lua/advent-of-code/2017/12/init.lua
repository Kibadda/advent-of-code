local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "12")

function M:parse_input(file)
  self.input = {}
  for line in file:lines() do
    local split = line:only_ints()
    self.input[split[1]] = {}
    for i = 2, #split do
      self.input[split[1]][split[i]] = true
    end
  end
end

function M:solver(id)
  local group = {}
  local queue = { id }
  while #queue > 0 do
    local p = table.remove(queue, 1)
    if not group[p] then
      group[p] = true
      for i in pairs(self.input[p]) do
        queue[#queue + 1] = i
      end
    end
  end
  return group
end

function M:solve1()
  self.solution:add("1", table.count(self:solver(0)))
end

function M:solve2()
  local groups = {}
  for id in pairs(self.input) do
    local found = false
    for _, g in ipairs(groups) do
      if g[id] then
        found = true
        break
      end
    end
    if not found then
      groups[#groups + 1] = self:solver(id)
    end
  end
  self.solution:add("2", #groups)
end

M:run()

return M
