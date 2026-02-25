--- @class AOCDay201803: AOCDay
--- @field input { id: integer, x: integer, y: integer, width: integer, height: integer }[]
local M = require("advent-of-code.AOCDay"):new("2018", "03")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local ints = line:only_ints()
    table.insert(self.input, {
      id = ints[1],
      x = ints[3],
      y = ints[2],
      height = ints[5],
      width = ints[4],
    })
  end
end

--- @param find_alone_claim boolean
function M:solver(find_alone_claim)
  local hash = {}
  local map = {}

  for _, claim in ipairs(self.input) do
    map[claim.id] = {}
    for x = claim.x, claim.x + claim.height - 1 do
      for y = claim.y, claim.y + claim.width - 1 do
        local key = V(x, y):string()
        table.insert(map[claim.id], key)
        hash[key] = (hash[key] or 0) + 1
      end
    end
  end

  if find_alone_claim then
    for id, claims in pairs(map) do
      if
        table.reduce(claims, true, function(is_alone, claim)
          return is_alone and hash[claim] == 1
        end)
      then
        return id
      end
    end
  else
    return table.reduce(hash, 0, function(sum, claims)
      return sum + (claims > 1 and 1 or 0)
    end, pairs)
  end
end

function M:solve1()
  return self:solver(false)
end

function M:solve2()
  return self:solver(true)
end

M:run()
