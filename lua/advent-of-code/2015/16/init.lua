--- @class AOCDay201516: AOCDay
--- @field input table<string, number>[]
local M = require("advent-of-code.AOCDay"):new("2015", "16")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local dna = {}
    for _, d in ipairs(line:split ",") do
      local split = d:split ": "
      dna[split[1]] = tonumber(split[2])
    end
    table.insert(self.input, dna)
  end
end

function M:solver(fun)
  for i, aunt in ipairs(self.input) do
    if
      (aunt.children == nil or aunt.children == 3)
      and (aunt.samoyeds == nil or aunt.samoyeds == 2)
      and (aunt.akitas == nil or aunt.akitas == 0)
      and (aunt.vizslas == nil or aunt.vizslas == 0)
      and (aunt.cars == nil or aunt.cars == 2)
      and (aunt.perfumes == nil or aunt.perfumes == 1)
      and fun(aunt)
    then
      return i
    end
  end
end

function M:solve1()
  return self:solver(function(aunt)
    return (aunt.cats == nil or aunt.cats == 7)
      and (aunt.pomeranians == nil or aunt.pomeranians == 3)
      and (aunt.goldfish == nil or aunt.goldfish == 5)
      and (aunt.trees == nil or aunt.trees == 3)
  end)
end

function M:solve2()
  return self:solver(function(aunt)
    return (aunt.cats == nil or aunt.cats > 7)
      and (aunt.pomeranians == nil or aunt.pomeranians < 3)
      and (aunt.goldfish == nil or aunt.goldfish < 5)
      and (aunt.trees == nil or aunt.trees > 3)
  end)
end

M:run()
