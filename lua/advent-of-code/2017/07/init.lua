local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "07")

function M:parse_input(file)
  self.input = {}
  for line in file:lines() do
    local split = line:split()
    self.input[split[1]] = {
      weight = tonumber(split[2]:sub(2, #split[2] - 1)),
      children = {},
    }

    if #split > 2 then
      for i = 4, #split do
        self.input[split[1]].children[#self.input[split[1]].children + 1] = split[i]:gsub(",", "")
      end
    end
  end
end

function M:solve1()
  local discs = table.deepcopy(self.input)
  local root
  for name1 in pairs(discs) do
    local found = false
    for name2, data2 in pairs(discs) do
      if name1 ~= name2 then
        for _, child in ipairs(data2.children) do
          if child == name1 then
            found = true
            break
          end
        end
        if found then
          break
        end
      end
    end
    if not found then
      root = name1
    end
  end
  self.solution:add("1", root)
end

function M:solve2()
  local function weight(disc)
    local sum = self.input[disc].weight
    for _, child in ipairs(self.input[disc].children) do
      sum = sum + weight(child)
    end
    return sum
  end
  local current = self.solution["1"]
  local prev
  local change
  while true do
    local weights = {}
    for _, child in ipairs(self.input[current].children) do
      local w = weight(child)
      weights[w] = weights[w] or {}
      table.insert(weights[w], child)
    end
    local right = table.reduce(weights, 0, function(carry, names, w)
      if carry ~= 0 then
        return carry
      end

      return #names > 1 and w or 0
    end, pairs)
    local wrong = table.reduce(weights, 0, function(carry, names, w)
      if carry ~= 0 then
        return carry
      end

      return #names == 1 and w or 0
    end, pairs)

    if wrong > 0 then
      current = weights[wrong][1]
      prev = right
    else
      change = prev - #self.input[current].children * right
      break
    end
  end
  self.solution:add("2", change)
end

M:run(false)

return M
