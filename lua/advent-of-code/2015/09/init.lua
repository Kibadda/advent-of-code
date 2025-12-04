--- @class AOCDay201509: AOCDay
--- @field input table<string, table<string, number>>
local M = require("advent-of-code.AOC").create("2015", "09")

--- @param file file*
function M:parse(file)
  for line in file:lines() do
    local words = string.split(line, " ")

    self.input[words[1]] = self.input[words[1]] or {}
    self.input[words[3]] = self.input[words[3]] or {}

    self.input[words[1]][words[3]] = tonumber(words[5])
    self.input[words[3]][words[1]] = tonumber(words[5])
  end
end

function M:solver(compare, bound)
  local count = table.count(self.input)
  local start = { available = table.keys(self.input), route = {} }

  return treesearch {
    start = start,
    depth = true,
    bound = bound,
    exit = function(current)
      return #current.route == count
    end,
    step = function(current)
      local n = {}
      for i, name in ipairs(current.available) do
        local copy = table.deepcopy(current)
        table.remove(copy.available, i)
        table.insert(copy.route, name)
        table.insert(n, copy)
      end
      return n
    end,
    compare = function(s, c)
      local distance = 0
      for i = 1, count - 1 do
        distance = distance + self.input[c.route[i]][c.route[i + 1]]
      end
      return compare(s, distance)
    end,
  }
end

function M:solve1()
  return self:solver(math.min, math.huge)
end

function M:solve2()
  return self:solver(math.max, -math.huge)
end

M:run()

return M
