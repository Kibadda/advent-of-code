--- @class AOCDay202404: AOCDay
--- @field input string[][]
local M = require("advent-of-code.AOCDay"):new("2024", "04")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:to_list())
  end
end

function M:solve1()
  local directions = V(0, 0):adjacent(8)
  local mas = { "M", "A", "S" }

  return table.reduce(self.input, 0, function(sum, row, i)
    return table.reduce(row, sum, function(row_sum, c, j)
      if c ~= "X" then
        return row_sum
      end

      return table.reduce(directions, row_sum, function(s, dir)
        for k = 1, 3 do
          local pos = V(i, j) + dir * k

          if not self.input[pos.x] or self.input[pos.x][pos.y] ~= mas[k] then
            return s
          end
        end

        return s + 1
      end)
    end)
  end)
end

function M:solve2()
  return table.reduce(self.input, 0, function(sum, row, i)
    return table.reduce(row, sum, function(row_sum, c, j)
      if c ~= "A" or i == 1 or i == #self.input or j == 1 or j == #row then
        return row_sum
      end

      local tl = V(i - 1, j - 1)
      local br = V(i + 1, j + 1)
      local tr = V(i - 1, j + 1)
      local bl = V(i + 1, j - 1)

      if
        (
          (self.input[tl.x][tl.y] == "M" and self.input[br.x][br.y] == "S")
          or (self.input[tl.x][tl.y] == "S" and self.input[br.x][br.y] == "M")
        )
        and (
          (self.input[tr.x][tr.y] == "M" and self.input[bl.x][bl.y] == "S")
          or (self.input[tr.x][tr.y] == "S" and self.input[bl.x][bl.y] == "M")
        )
      then
        return row_sum + 1
      end

      return row_sum
    end)
  end)
end

M:run()
