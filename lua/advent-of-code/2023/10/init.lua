--- @class AOCDay202310: AOCDay
--- @field input { grid: string[], start: Vector, path: Vector[] }
local M = require("advent-of-code.AOCDay"):new("2023", "10")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    grid = lines,
    path = setmetatable({}, {
      __index = function(t, key)
        t[key] = {}
        return t[key]
      end,
    }),
  }

  for i, line in ipairs(lines) do
    local s = string.find(line, "S")
    if s then
      self.input.start = V(i, s)
    end
  end
end

function M:solve1()
  local current = self.input.start
  self.input.path[current.x][current.y] = true
  local last_dir = nil

  repeat
    for _, dir in ipairs { V(1, 0), V(-1, 0), V(0, 1), V(0, -1) } do
      local cur_pos = self.input.grid[current.x]:at(current.y) --[[@as string]]

      if self.input.grid[current.x + dir.x] and self.input.grid[current.x + dir.x]:at(current.y + dir.y) then
        local new_pos = self.input.grid[current.x + dir.x]:at(current.y + dir.y) --[[@as string]]

        if
          (
            dir == V(1, 0)
            and last_dir ~= V(-1, 0)
            and table.contains({ "S", "|", "F", "7" }, cur_pos)
            and table.contains({ "S", "|", "J", "L" }, new_pos)
          )
          or (dir == V(-1, 0) and last_dir ~= V(1, 0) and table.contains({ "S", "|", "L", "J" }, cur_pos) and table.contains(
            { "S", "|", "F", "7" },
            new_pos
          ))
          or (dir == V(0, 1) and last_dir ~= V(0, -1) and table.contains({ "S", "-", "F", "L" }, cur_pos) and table.contains(
            { "S", "-", "J", "7" },
            new_pos
          ))
          or (
            dir == V(0, -1)
            and last_dir ~= V(0, 1)
            and table.contains({ "S", "-", "J", "7" }, cur_pos)
            and table.contains({ "S", "-", "F", "L" }, new_pos)
          )
        then
          current = current + dir
          last_dir = dir
          break
        end
      end
    end

    self.input.path[current.x][current.y] = true
  until current == self.input.start

  return (table.reduce(self.input.path, 0, function(count, row)
    return count + table.count(row)
  end, pairs)) / 2
end

function M:solve2()
  local in_bounds = 0

  for i = 1, #self.input.grid do
    for j = 1, #self.input.grid[i] do
      if not self.input.path[i][j] then
        local count = 0

        for k = 1, j - 1 do
          if
            self.input.path[i][k] and table.contains({ "|", "J", "L", "S" }, self.input.grid[i]:at(k) --[[@as string]])
          then
            count = count + 1
          end
        end

        if count % 2 == 1 then
          in_bounds = in_bounds + 1
        end
      end
    end
  end

  return in_bounds
end

M:run()
