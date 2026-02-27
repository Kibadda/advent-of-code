--- @class AOCDay201812: AOCDay
--- @field input { pots: string, rules: table<string, string> }
local M = require("advent-of-code.AOCDay"):new("2018", "12")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    rules = {},
  }

  local parsing_rules = false

  for _, line in ipairs(lines) do
    if line == "" then
      parsing_rules = true
    elseif parsing_rules then
      local split = line:split()
      self.input.rules[split[1]] = split[3]
    else
      self.input.pots = line:sub(16)
    end
  end
end

function M:solver(generations)
  local pots = self.input.pots

  local function calculate(gens)
    return table.reduce(string.to_list(pots), 0, function(sum, plant, i)
      if plant == "#" then
        return sum + (i - gens * 5 - 1)
      end

      return sum
    end)
  end

  local before_before_before, before_before, before = 0, 0, 0

  for i = 1, generations do
    if i == 300 then
      break
    end
    pots = "....." .. pots .. "....."
    --- @type string
    local new_pots = pots

    for j = 3, #pots - 2 do
      local rule = self.input.rules[pots:sub(j - 2, j + 2)]

      if rule then
        new_pots = new_pots:sub(1, j - 1) .. rule .. new_pots:sub(j + 1)
      end
    end

    pots = new_pots

    local calc = calculate(i)

    if before_before_before - before_before == before_before - before and before_before - before == before - calc then
      return calc + (generations - i) * (calc - before)
    end

    before_before_before = before_before
    before_before = before
    before = calc
  end

  return calculate(generations)
end

function M:solve1()
  return self:solver(20)
end

function M:solve2()
  return self:solver(50000000000)
end

M:run()
