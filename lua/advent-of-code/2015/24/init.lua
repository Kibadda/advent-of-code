--- @class AOCDay201524: AOCDay
--- @field input number[]
local M = require("advent-of-code.AOCDay"):new("2015", "24")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, tonumber(line))
  end
end

function M:solver(num_sacks)
  local num_per_sack = table.sum(self.input) / num_sacks

  local hash = {}

  return treesearch({
    start = { packages = self.input, sack = {} },
    bound = { size = math.huge, quantum = math.huge },
    depth = true,
    exit = function(current)
      return table.sum(current.sack) >= num_per_sack
    end,
    compare = function(solution, current)
      local quantum = table.prod(current.sack)
      if
        table.sum(current.sack) > num_per_sack
        or #current.sack > solution.size
        or (#current.sack == solution.size and quantum >= solution.quantum)
      then
        return solution
      else
        return {
          quantum = quantum,
          size = #current.sack,
        }
      end
    end,
    step = function(current, solution)
      local steps = {}
      local key = table.concat(current.sack, "|")

      if
        hash[key]
        or #current.sack >= solution.size
        or (#current.sack < solution.size and table.prod(current.sack) >= solution.quantum)
      then
      else
        hash[key] = true
        for i, package in ipairs(current.packages) do
          if table.sum(current.sack) + package <= num_per_sack then
            local n = table.deepcopy(current)
            table.remove(n.packages, i)
            table.insert(n.sack, package)
            table.sort(n.sack)
            table.insert(steps, n)
          end
        end
      end

      return steps
    end,
  }).quantum
end

function M:solve1()
  return self:solver(3)
end

function M:solve2()
  return self:solver(4)
end

M:run()
