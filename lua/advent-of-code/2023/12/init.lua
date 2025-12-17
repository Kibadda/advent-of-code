--- @class AOCDay202312: AOCDay
--- @field input { record: string, springs: integer[] }[]
local M = require("advent-of-code.AOCDay"):new("2023", "12")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local split = line:split()
    table.insert(self.input, {
      record = split[1],
      springs = split[2]:only_ints(),
    })
  end
end

local function walk(s, numbers)
  local permutations = {}

  local function clear()
    permutations = {}
    setmetatable(permutations, {
      __index = function(t, k)
        t[k] = 0
        return t[k]
      end,
    })
  end

  clear()

  permutations["0|0"] = 1

  for i = 1, #s do
    local next = {}

    for key, count in pairs(permutations) do
      local split = key:split "|"
      local id = tonumber(split[1])
      local amount = tonumber(split[2])
      if s:at(i) ~= "#" then
        if amount == 0 then
          table.insert(next, { id, amount, count })
        elseif amount == numbers[id + 1] then
          table.insert(next, { id + 1, 0, count })
        end
      end
      if s:at(i) ~= "." then
        if id < #numbers and amount < numbers[id + 1] then
          table.insert(next, { id, amount + 1, count })
        end
      end
    end

    clear()

    for _, n in ipairs(next) do
      local k = n[1] .. "|" .. n[2]
      permutations[k] = permutations[k] + n[3]
    end
  end

  return table.reduce(permutations, 0, function(count, perm, key)
    local split = key:split "|"
    local id = tonumber(split[1])
    local amount = tonumber(split[2])

    if id == #numbers or (id == #numbers - 1 and amount == numbers[id + 1]) then
      return count + perm
    else
      return count
    end
  end, pairs)
end

function M:solver()
  return table.reduce(self.input, 0, function(count, arrangement)
    return count + walk(arrangement.record, arrangement.springs)
  end)
end

function M:solve1()
  return self:solver()
end

function M:solve2()
  self.input = table.map(self.input, function(arrangement)
    return {
      record = arrangement.record:rep(5, "?"),
      springs = table.concat(arrangement.springs, ","):rep(5, ","):only_ints(),
    }
  end)

  return self:solver()
end

M:run()
