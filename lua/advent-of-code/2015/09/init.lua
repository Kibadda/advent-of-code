local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "09")

function M:parse_input(file)
  local city_map = {}
  for line in file:lines() do
    local split = line:split()
    if city_map[split[1]] == nil then
      city_map[split[1]] = table.count(city_map) + 1
    end
    if city_map[split[3]] == nil then
      city_map[split[3]] = table.count(city_map) + 1
    end
    if self.input[city_map[split[1]]] == nil then
      self.input[city_map[split[1]]] = {}
      self.input[city_map[split[1]]][city_map[split[1]]] = math.huge
    end
    if self.input[city_map[split[3]]] == nil then
      self.input[city_map[split[3]]] = {}
      self.input[city_map[split[3]]][city_map[split[3]]] = math.huge
    end

    self.input[city_map[split[1]]][city_map[split[3]]] = tonumber(split[5])
    self.input[city_map[split[3]]][city_map[split[1]]] = tonumber(split[5])
  end

  for i = 1, #self.input do
    for j = 1, #self.input do
      for k = 1, #self.input do
        self.input[j][k] = math.min(self.input[j][k], self.input[j][i] + self.input[i][k])
      end
    end
  end
end

function M:solve1()
  vim.pretty_print(self.input)
  self.solution:add("1", nil)
end

function M:solve2()
  self.solution:add("2", nil)
end

M:run(true)

return M
