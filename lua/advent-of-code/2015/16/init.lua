local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "16")

--[[
children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1
--]]

function M:parse_input(file)
  for line in file:lines() do
    local dna = {}
    for _, d in ipairs(line:split ",") do
      local split = d:split ": "
      dna[split[1]] = tonumber(split[2])
    end
    table.insert(self.input, dna)
  end
end

function M:solve1()
  local index
  for i, aunt in ipairs(self.input) do
    if
      (aunt.children == nil or aunt.children == 3)
      and (aunt.cats == nil or aunt.cats == 7)
      and (aunt.samoyeds == nil or aunt.samoyeds == 2)
      and (aunt.pomeranians == nil or aunt.pomeranians == 3)
      and (aunt.akitas == nil or aunt.akitas == 0)
      and (aunt.vizslas == nil or aunt.vizslas == 0)
      and (aunt.goldfish == nil or aunt.goldfish == 5)
      and (aunt.trees == nil or aunt.trees == 3)
      and (aunt.cars == nil or aunt.cars == 2)
      and (aunt.perfumes == nil or aunt.perfumes == 1)
    then
      index = i
      break
    end
  end
  self.solution:add("1", index)
end

function M:solve2()
  local index
  for i, aunt in ipairs(self.input) do
    if
      (aunt.children == nil or aunt.children == 3)
      and (aunt.cats == nil or aunt.cats > 7)
      and (aunt.samoyeds == nil or aunt.samoyeds == 2)
      and (aunt.pomeranians == nil or aunt.pomeranians < 3)
      and (aunt.akitas == nil or aunt.akitas == 0)
      and (aunt.vizslas == nil or aunt.vizslas == 0)
      and (aunt.goldfish == nil or aunt.goldfish < 5)
      and (aunt.trees == nil or aunt.trees > 3)
      and (aunt.cars == nil or aunt.cars == 2)
      and (aunt.perfumes == nil or aunt.perfumes == 1)
    then
      index = i
      break
    end
  end
  self.solution:add("2", index)
end

M:run(false)

return M
