--- @class AOCDay202313: AOCDay
--- @field input string[][][]
local M = require("advent-of-code.AOCDay"):new("2023", "13")

--- @param lines string[]
function M:parse(lines)
  local mirror = {}

  for _, line in ipairs(lines) do
    if line == "" then
      table.insert(self.input, mirror)
      mirror = {}
    else
      table.insert(mirror, line:to_list())
    end
  end

  table.insert(self.input, mirror)
end

function M:solver(differences)
  --- @param mirror string[][]
  --- @return string
  local function col_concat(mirror, col)
    local str = ""

    for _, row in ipairs(mirror) do
      str = str .. row[col]
    end

    return str
  end

  return table.reduce(self.input, 0, function(sum, mirror)
    for i = 1, #mirror - 1 do
      local count
      if i <= #mirror / 2 then
        count = i - 1
      else
        count = #mirror - i - 1
      end

      local found = 0
      for j = 0, count do
        local a = table.concat(mirror[i - j])
        local b = table.concat(mirror[i + 1 + j])
        if a ~= b then
          found = found + a:levenshtein(b)
        end
      end

      if found == differences then
        return sum + 100 * i
      end
    end

    for i = 1, #mirror[1] - 1 do
      local count
      if i <= #mirror[1] / 2 then
        count = i - 1
      else
        count = #mirror[1] - i - 1
      end

      local found = 0
      for j = 0, count do
        local a = col_concat(mirror, i - j)
        local b = col_concat(mirror, i + 1 + j)
        if a ~= b then
          found = found + a:levenshtein(b)
        end
      end

      if found == differences then
        return sum + i
      end
    end

    return sum
  end)
end

function M:solve1()
  return self:solver(0)
end

function M:solve2()
  return self:solver(1)
end

M:run()
