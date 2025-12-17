--- @class AOCDay202507: AOCDay
--- @field input string[][]
local M = require("advent-of-code.AOCDay"):new("2025", "07")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:to_list())
  end
end

function M:solve1()
  local grid = table.deepcopy(self.input)

  local split = 0
  for i, row in ipairs(grid) do
    for j, col in ipairs(row) do
      if col == "S" or col == "|" then
        if i + 1 <= #grid then
          if grid[i + 1][j] == "^" then
            split = split + 1
            if j - 1 > 0 then
              grid[i + 1][j - 1] = "|"
            end
            if j + 1 <= #row then
              grid[i + 1][j + 1] = "|"
            end
          else
            grid[i + 1][j] = "|"
          end
        end
      end
    end
  end

  return split
end

function M:solve2()
  local beams = { [table.concat(self.input[1]):find "S"] = 1 }

  for i = 1, #self.input - 1 do
    local new_beams = {}
    for beam, number in spairs(beams) do
      if self.input[i + 1][beam] == "^" then
        if beam - 1 >= 1 then
          new_beams[beam - 1] = (new_beams[beam - 1] or 0) + number
        end
        if beam + 1 <= #self.input[i] then
          new_beams[beam + 1] = (new_beams[beam + 1] or 0) + number
        end
      else
        new_beams[beam] = (new_beams[beam] or 0) + number
      end
    end
    beams = new_beams
  end

  return table.sum(beams, pairs)
end

M:run()
