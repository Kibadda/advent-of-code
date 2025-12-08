--- @class AOCDay201622: AOCDay
--- @field input { size: number, used: number, avail: number, use: number }[][]
local M = require("advent-of-code.AOC").create("2016", "22")

--- @param file file*
function M:parse(file)
  for line in file:lines() do
    local ints = line:only_ints()

    if #ints > 0 then
      self.input[ints[1] + 1] = self.input[ints[1] + 1] or {}
      self.input[ints[1] + 1][ints[2] + 1] = {
        size = ints[3],
        used = ints[4],
        avail = ints[5],
      }
    end
  end
end

function M:solve1()
  local pairs = 0

  for i, row1 in ipairs(self.input) do
    for j, cell1 in ipairs(row1) do
      for k, row2 in ipairs(self.input) do
        for l, cell2 in ipairs(row2) do
          if (i ~= k or j ~= l) and cell1.used > 0 and cell2.avail >= cell1.used then
            pairs = pairs + 1
          end
        end
      end
    end
  end

  return pairs
end

function M:solve2()
  print(table.concat(
    table.map(self.input, function(row)
      return table.concat(
        table.map(row, function(cell)
          if cell.used == 0 then
            return "__/" .. cell.size
          elseif cell.used > 150 then
            return "|/" .. cell.size
          else
            return cell.used .. "/" .. cell.size
          end
        end),
        " "
      )
    end),
    "\n"
  ))
end

M:run()
