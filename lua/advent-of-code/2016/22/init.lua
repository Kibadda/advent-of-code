--- @class AOCDay201622: AOCDay
--- @field input { size: number, used: number, avail: number, use: number }[][]
local M = require("advent-of-code.AOCDay"):new("2016", "22")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
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

  local steps = 0
  --- @type Vector
  local pos

  for i, row in ipairs(self.input) do
    for j, cell in ipairs(row) do
      if cell.used == 0 then
        pos = V(i, j)
        break
      end
    end
  end

  -- walk to the wall
  while self.input[pos.x][pos.y - 1].used < 150 do
    pos.y = pos.y - 1
    steps = steps + 1
  end

  -- walk up the wall
  while self.input[pos.x][pos.y - 1].used > 150 do
    pos.x = pos.x - 1
    steps = steps + 1
  end

  -- walk all the way to the left
  while pos.y > 1 do
    pos.y = pos.y - 1
    steps = steps + 1
  end

  -- walk all the way to the bottom
  while self.input[pos.x + 1] do
    pos.x = pos.x + 1
    steps = steps + 1
  end

  -- walk all the way to the top
  while pos.x > 2 do
    pos.x = pos.x - 1
    steps = steps + 5
  end

  return steps
end

M:run()
