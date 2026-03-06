--- @class AOCDay201818: AOCDay
--- @field input ("."|"#"|"|")[][]
local M = require("advent-of-code.AOCDay"):new("2018", "18")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:to_list())
  end
end

function M:solver(minutes)
  local hash = {}

  local input = table.deepcopy(self.input)
  local skipped = false

  local m = 1
  while m <= minutes do
    local grid = table.deepcopy(input)

    for i, row in ipairs(input) do
      for j, c in ipairs(row) do
        local trees = 0
        local lumberyards = 0
        for _, pos in ipairs(V(i, j):adjacent(8)) do
          if input[pos.x] then
            if input[pos.x][pos.y] == "|" then
              trees = trees + 1
            elseif input[pos.x][pos.y] == "#" then
              lumberyards = lumberyards + 1
            end
          end
        end

        if c == "." and trees >= 3 then
          grid[i][j] = "|"
        elseif c == "|" and lumberyards >= 3 then
          grid[i][j] = "#"
        elseif c == "#" and (trees == 0 or lumberyards == 0) then
          grid[i][j] = "."
        end
      end
    end

    input = grid

    local key = table.concat(table.map(input, function(row)
      return table.concat(row)
    end))

    if not skipped and hash[key] then
      skipped = true
      m = minutes - ((minutes - m + 1) % (m - hash[key])) + 1
    else
      hash[key] = m
    end

    m = m + 1
  end

  local result = table.reduce(input, { trees = 0, lumberyards = 0 }, function(sum, row)
    return table.reduce(row, sum, function(row_sum, c)
      if c == "#" then
        row_sum.lumberyards = row_sum.lumberyards + 1
      elseif c == "|" then
        row_sum.trees = row_sum.trees + 1
      end

      return row_sum
    end)
  end)

  return result.trees * result.lumberyards
end

function M:solve1()
  return self:solver(10)
end

function M:solve2()
  return self:solver(1000000000)
end

M:run()
