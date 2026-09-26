--- @class AOCDay201906: AOCDay
--- @field input table<string, string>
local M = require("advent-of-code.AOCDay"):new("2019", "06")

--- @param lines string[]
function M:parse(lines)
  self.input = {}

  for _, line in ipairs(lines) do
    local split = line:split "%)"
    self.input[split[2]] = split[1]
  end
end

function M:solve1()
  local count = 0

  for _, p in ipairs(table.keys(self.input)) do
    local c = self.input[p]
    while c do
      count = count + 1
      c = self.input[c]
    end
  end

  return count
end

function M:solve2()
  local map = {}

  for k, v in pairs(self.input) do
    map[v] = map[v] or {}
    map[v][k] = true
    map[k] = map[k] or {}
    map[k][v] = true
  end

  local result = treesearch {
    start = { map = map, jumps = 0 },
    depth = false,
    exit = function(current)
      return table.keys(current.map.SAN)[1] == table.keys(current.map.YOU)[1]
    end,
    memoize = function(current)
      return table.keys(current.map.YOU)[1], current.jumps
    end,
    step = function(current)
      local steps = {}

      local orb = table.keys(current.map.YOU)[1]

      for k in spairs(current.map[orb]) do
        if k ~= "YOU" then
          local m = table.deepcopy(current.map)
          m.YOU[orb] = nil
          m[orb].YOU = nil
          m.YOU[k] = true
          m[k].YOU = true

          table.insert(steps, {
            map = m,
            jumps = current.jumps + 1,
          })
        end
      end

      return steps
    end,
  }

  return result.jumps
end

M:run()
