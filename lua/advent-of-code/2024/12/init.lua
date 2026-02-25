--- @class AOCDay202412: AOCDay
--- @field input string[][]
local M = require("advent-of-code.AOCDay"):new("2024", "12")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:to_list())
  end
end

local function generate_key(c, i, j)
  return ("%s|%s|%s"):format(c, i, j)
end

--- @param score fun(table): integer
function M:solver(score)
  local regions = {}

  --- @param pos Vector
  --- @param c string
  --- @return integer?
  local function find(pos, c)
    for i, region in ipairs(regions) do
      if region[generate_key(c, pos.x, pos.y)] then
        return i
      end
    end
  end

  for i, row in ipairs(self.input) do
    for j, c in ipairs(row) do
      local left, top
      if j > 1 then
        left = find(V(i, j - 1), c)
      end
      if i > 1 then
        top = find(V(i - 1, j), c)
      end

      if left == top then
        top = nil
      end

      local key = generate_key(c, i, j)

      if left and top then
        for k in pairs(regions[math.max(left, top)]) do
          regions[math.min(left, top)][k] = true
        end
        table.remove(regions, math.max(left, top))
        regions[math.min(left, top)][key] = true
      elseif left then
        regions[left][key] = true
      elseif top then
        regions[top][key] = true
      else
        table.insert(regions, { [key] = true })
      end
    end
  end

  return table.reduce(regions, 0, function(sum, region)
    return sum + table.count(region) * score(region)
  end)
end

function M:solve1()
  return self:solver(function(region)
    return table.reduce(region, 0, function(perimeter, _, key)
      local c, i, j = unpack(key:split "|")
      i = tonumber(i)
      j = tonumber(j)

      if i == 0 or not region[generate_key(c, i - 1, j)] then
        perimeter = perimeter + 1
      end
      if j == 0 or not region[generate_key(c, i, j - 1)] then
        perimeter = perimeter + 1
      end
      if not region[generate_key(c, i + 1, j)] then
        perimeter = perimeter + 1
      end
      if not region[generate_key(c, i, j + 1)] then
        perimeter = perimeter + 1
      end

      return perimeter
    end, pairs)
  end)
end

function M:solve2()
  return self:solver(function(region)
    return table.reduce(region, 0, function(sides, _, key)
      local c, i, j = unpack(key:split "|")
      i = assert(tonumber(i))
      j = assert(tonumber(j))
      local pos = V(i, j)

      sides = sides
        + table.count(table.filter(table.windows({ V(-1, 0), V(0, 1), V(1, 0), V(0, -1), V(-1, 0) }, 2), function(dirs)
          local sp1 = pos + dirs[1]
          local sp2 = pos + dirs[2]
          local cp = pos + dirs[1] + dirs[2]
          local s1 = self.input[sp1.x] and self.input[sp1.x][sp1.y]
          local s2 = self.input[sp2.x] and self.input[sp2.x][sp2.y]
          local corner = self.input[cp.x] and self.input[cp.x][cp.y]

          return (c ~= s1 and c ~= s2) or (c == s1 and c == s2 and c ~= corner)
        end))

      return sides
    end, pairs)
  end)
end

M:run()
