--- @class AOCDay201721: AOCDay
--- @field input { input: string[][], output: string[][] }[]
local M = require("advent-of-code.AOCDay"):new("2017", "21")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local split = line:split " => "

    table.insert(self.input, {
      input = table.map(split[1]:split "/", function(row)
        return row:to_list()
      end),
      output = table.map(split[2]:split "/", function(row)
        return row:to_list()
      end),
    })
  end
end

local function rotate(grid)
  local g = {}

  for i = 1, #grid do
    g[i] = {}
    for j = 1, #grid do
      g[i][j] = grid[j][#grid - i + 1]
    end
  end

  return g
end

local function flip(grid)
  local g = {}

  for i = 1, #grid do
    g[i] = {}
    for j = 1, #grid do
      g[i][j] = grid[i][#grid - j + 1]
    end
  end

  return g
end

local function any_equal(a, b)
  return #a == #b
    and table.reduce(
      {
        b,
        rotate(b),
        rotate(rotate(b)),
        rotate(rotate(rotate(b))),
        flip(b),
        rotate(flip(b)),
        rotate(rotate(flip(b))),
        rotate(rotate(rotate(flip(b)))),
      },
      false,
      function(e, grid)
        if e then
          return true
        end

        for i = 1, #a do
          for j = 1, #grid do
            if a[i][j] ~= grid[i][j] then
              return false
            end
          end
        end

        return true
      end
    )
end

function M:solver(iterations)
  local grid = {
    { ".", "#", "." },
    { ".", ".", "#" },
    { "#", "#", "#" },
  }

  for _ = 1, iterations do
    local grids = {}

    local amount
    if #grid % 2 == 0 then
      amount = 2
    elseif #grid % 3 == 0 then
      amount = 3
    else
      return #grid
    end

    for i = 1, #grid, amount do
      for j = 1, #grid, amount do
        local g = {}

        for k = 1, amount do
          g[k] = {}
          for l = 1, amount do
            g[k][l] = grid[i + k - 1][j + l - 1]
          end
        end
        table.insert(grids, g)
      end
    end

    for i, g in ipairs(grids) do
      for _, conversion in ipairs(self.input) do
        if any_equal(conversion.input, g) then
          grids[i] = conversion.output
          break
        end
      end
    end

    grid = {}

    local step = #grids[1]
    local max = math.sqrt(#grids) * step
    local i, j = 1, 1
    for _, g in ipairs(grids) do
      for k = 1, #g do
        grid[i + k - 1] = grid[i + k - 1] or {}
        for l = 1, #g do
          grid[i + k - 1][j + l - 1] = g[k][l]
        end
      end
      j = j + step
      if j > max then
        j = 1
        i = i + step
      end
    end
  end

  return table.sum(table.map(grid, function(row)
    return table.reduce(row, 0, function(row_sum, cell)
      return row_sum + (cell == "#" and 1 or 0)
    end)
  end))
end

function M:solve1()
  return self:solver(self.test and 2 or 5)
end

function M:solve2()
  return self:solver(18)
end

M:run()
