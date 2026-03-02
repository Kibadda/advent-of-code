--- @class AOCDay201814: AOCDay
--- @field input integer
local M = require("advent-of-code.AOCDay"):new("2018", "14")

--- @param lines string[]
function M:parse(lines)
  self.input = assert(tonumber(lines[1]))
end

--- @param func fun(value: integer, recipes: integer[]): boolean?
function M:solver(func)
  local recipes = { 3, 7 }
  local elves = { 1, 2 }
  local value = 0
  local modulo = math.pow(10, math.ceil(math.log10(self.input)))

  for _ = 1, math.huge do
    local recipe = recipes[elves[1]] + recipes[elves[2]]

    if recipe >= 10 then
      recipes[#recipes + 1] = 1
      value = (value * 10 + 1) % modulo

      if func(value, recipes) then
        break
      end
    end

    recipes[#recipes + 1] = recipe % 10
    value = (value * 10 + recipe % 10) % modulo

    if func(value, recipes) then
      break
    end

    elves = {
      ((elves[1] + recipes[elves[1]]) % #recipes) + 1,
      ((elves[2] + recipes[elves[2]]) % #recipes) + 1,
    }
  end
end

function M:solve1()
  local result

  self:solver(function(_, recipes)
    if #recipes >= self.input + 10 then
      result = table.concat(recipes, nil, self.input + 1)

      return true
    end
  end)

  return result
end

function M:solve2()
  local result

  self:solver(function(value, recipes)
    if value == self.input then
      result = #recipes - math.log10(self.input)
      return true
    end
  end)

  return result
end

M:run()
