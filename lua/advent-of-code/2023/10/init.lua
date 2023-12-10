local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay202310: AOCDay
---@field input { grid: string[], start: Vector }
local M = AOC.create("2023", "10")

---@param file file*
function M:parse(file)
  self.input = {
    grid = {},
  }

  local i = 1
  for line in file:lines() do
    if string.match(line, "S") then
      self.input.start = V(i, string.find(line, "S"))
    end
    table.insert(self.input.grid, line)
    i = i + 1
  end
end

function M:solve1()
  local current = self.input.start
  local path = { current }
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

    table.insert(path, current)
  until current == self.input.start

  return math.floor(#path / 2)
end

function M:solve2()
  -- 461 to low
  return nil
end

M:run()

return M
