--- @class AOCDay202406: AOCDay
--- @field input { grid: string[][], pos: Vector }
local M = require("advent-of-code.AOCDay"):new("2024", "06")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    grid = {},
  }

  for i, line in ipairs(lines) do
    table.insert(self.input.grid, line:to_list())

    if not self.input.pos then
      local s = line:find "%^"
      if s then
        self.input.pos = V(i, s)
      end
    end
  end
end

--- @param grid string[][]
--- @param check_loop false?
--- @return table
--- @overload fun(self: AOCDay202406, grid: string[][], check_loop: true): boolean
function M:solver(grid, check_loop)
  local visits = {}
  local loop = {}
  local dir = V(-1, 0)
  local pos = self.input.pos

  while true do
    if
      (dir.x == -1 and pos.x == 1)
      or (dir.x == 1 and pos.x == #grid)
      or (dir.y == -1 and pos.y == 1)
      or (dir.y == 1 and pos.y == #grid[pos.x])
    then
      break
    end

    local new = pos + dir

    if grid[new.x][new.y] == "#" then
      dir = dir * "R"
    else
      pos = new
    end

    visits[("%s|%s"):format(pos.x, pos.y)] = true

    if check_loop then
      local s = ("%s|%s|%s"):format(pos.x, pos.y, dir:string())

      if not loop[s] then
        loop[s] = true
      else
        return true
      end
    end
  end

  if not check_loop then
    return visits
  else
    return false
  end
end

function M:solve1()
  return table.count(self:solver(self.input.grid))
end

function M:solve2()
  local visits = self:solver(self.input.grid)

  return table.reduce(self.input.grid, 0, function(count, row, i)
    return table.reduce(row, count, function(row_count, _, j)
      if V(i, j) == self.input.pos or not visits[("%s|%s"):format(i, j)] then
        return row_count
      end

      local grid = table.deepcopy(self.input.grid)
      grid[i][j] = "#"

      if self:solver(grid, true) then
        return row_count + 1
      end

      return row_count
    end)
  end)
end

M:run()
