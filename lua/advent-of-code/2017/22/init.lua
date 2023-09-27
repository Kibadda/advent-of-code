local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "22")

function M:parse_input(file)
  self.input = {}
  local i = 0
  for line in file:lines() do
    i = i + 1
    self.input[i] = {}
    for j, c in ipairs(line:to_list()) do
      self.input[i][j] = c
    end
  end
end

---@param rounds integer
---@param burst fun(grid: table, pos: Vector, direction: Vector, infections: integer): Vector, integer
---@return integer
function M:solver(rounds, burst)
  local grid = table.deepcopy(self.input)
  local pos = V(math.ceil(#self.input / 2), math.ceil(#self.input[1] / 2))
  local direction = V(-1, 0)

  local infections = 0

  for _ = 1, rounds do
    grid[pos.x] = grid[pos.x] or {}
    grid[pos.x][pos.y] = grid[pos.x][pos.y] or "."

    direction, infections = burst(grid, pos, direction, infections)

    pos = pos + direction
  end

  return infections
end

function M:solve1()
  self.solution:add(
    "1",
    self:solver(10000, function(grid, pos, direction, infections)
      match(grid[pos.x][pos.y]) {
        ["."] = function()
          grid[pos.x][pos.y] = "#"
          direction = direction * "L"
          infections = infections + 1
        end,
        ["#"] = function()
          grid[pos.x][pos.y] = "."
          direction = direction * "R"
        end,
      }

      return direction, infections
    end)
  )
end

function M:solve2()
  self.solution:add(
    "2",
    self:solver(10000000, function(grid, pos, direction, infections)
      match(grid[pos.x][pos.y]) {
        ["."] = function()
          grid[pos.x][pos.y] = "W"
          direction = direction * "L"
        end,
        ["W"] = function()
          grid[pos.x][pos.y] = "#"
          infections = infections + 1
        end,
        ["#"] = function()
          grid[pos.x][pos.y] = "F"
          direction = direction * "R"
        end,
        ["F"] = function()
          grid[pos.x][pos.y] = "."
          direction = V(direction.x * -1, direction.y * -1)
        end,
      }

      return direction, infections
    end)
  )
end

M:run()

return M
