local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay202305: AOCDay
---@field input { seeds: integer[], functions: Function[] }
local M = AOC.create("2023", "05")

---@class Function
---@field mappings integer[][]
---@field new fun(self: Function, mappings: integer[][]): Function
---@field one fun(self: Function, v: integer): integer
---@field range fun(self: Function, v: integer[][]): integer[][]
local Function = {
  new = function(self, mappings)
    return setmetatable({ mappings = mappings }, {
      __index = self,
    })
  end,
  one = function(self, v)
    for i = 1, #self.mappings do
      local destination, source, range = unpack(self.mappings[i])

      if source <= v and v < source + range then
        return v + destination - source
      end
    end

    return v
  end,
  range = function(self, v)
    local ranges = {}
    for i = 1, #self.mappings do
      local destination, source, range = unpack(self.mappings[i])

      local new_ranges = {}
      while #v > 0 do
        local r = table.remove(v, 1)

        local before = { r[1], math.min(r[2], source) }
        local inter = { math.max(r[1], source), math.min(source + range, r[2]) }
        local after = { math.max(source + range, r[1]), r[2] }

        if before[1] < before[2] then
          table.insert(new_ranges, before)
        end
        if inter[1] < inter[2] then
          table.insert(ranges, { inter[1] - source + destination, inter[2] - source + destination })
        end
        if after[1] < after[2] then
          table.insert(new_ranges, after)
        end
      end

      v = new_ranges
    end

    for _, r in ipairs(v) do
      table.insert(ranges, r)
    end

    return ranges
  end,
}

---@param file file*
function M:parse(file)
  ---@type string[]
  local lines = file:read("*a"):split "\n"

  self.input = {
    seeds = lines[1]:only_ints(),
    functions = {},
  }

  local mappings = {}
  for i = 3, #lines do
    local ints = lines[i]:only_ints()
    if #ints == 0 then
      table.insert(self.input.functions, Function:new(mappings))
      mappings = {}
    else
      table.insert(mappings, ints)
    end
  end

  table.insert(self.input.functions, Function:new(mappings))
end

function M:solve1()
  return table.reduce(self.input.seeds, math.huge, function(min, seed)
    return math.min(
      min,
      table.reduce(self.input.functions, seed, function(s, fun)
        return fun:one(s)
      end)
    )
  end)
end

function M:solve2()
  return table.reduce(table.to_chunks(self.input.seeds, 2), math.huge, function(min, seed_range)
    return math.min(
      min,
      table.reduce(
        table.reduce(self.input.functions, { { seed_range[1], seed_range[2] + seed_range[1] } }, function(sr, fun)
          return fun:range(sr)
        end),
        math.huge,
        function(rm, range)
          return math.min(rm, range[1])
        end
      )
    )
  end)
end

M:run()

return M
