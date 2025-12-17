--- @class AOCDay202316: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2023", "16")

function M:solver(start)
  local queue = { start }
  local seen = {}
  local points = {}

  while #queue > 0 do
    --- @type { pos: Vector, dir: Vector }
    local current = table.remove(queue, 1)

    local key = ("%d|%d|%d|%d"):format(current.pos.x, current.pos.y, current.dir.x, current.dir.y)

    if
      self.input[current.pos.x]
      and current.pos.y > 0
      and self.input[current.pos.x]:at(current.pos.y)
      and not seen[key]
    then
      local s = self.input[current.pos.x]:at(current.pos.y)

      points[("%d|%d"):format(current.pos.x, current.pos.y)] = true
      seen[key] = true

      if s == "." then
        table.insert(queue, {
          pos = current.pos + current.dir,
          dir = current.dir,
        })
      elseif s == "/" then
        local new_dir
        if current.dir == V(0, 1) or current.dir == V(0, -1) then
          new_dir = current.dir * "L"
        else
          new_dir = current.dir * "R"
        end

        table.insert(queue, {
          pos = current.pos + new_dir,
          dir = new_dir,
        })
      elseif s == "\\" then
        local new_dir
        if current.dir == V(0, 1) or current.dir == V(0, -1) then
          new_dir = current.dir * "R"
        else
          new_dir = current.dir * "L"
        end

        table.insert(queue, {
          pos = current.pos + new_dir,
          dir = new_dir,
        })
      elseif s == "|" then
        if current.dir == V(0, 1) or current.dir == V(0, -1) then
          local new_dir_1 = current.dir * "L"
          table.insert(queue, {
            pos = current.pos + new_dir_1,
            dir = new_dir_1,
          })
          local new_dir_2 = current.dir * "R"
          table.insert(queue, {
            pos = current.pos + new_dir_2,
            dir = new_dir_2,
          })
        else
          table.insert(queue, {
            pos = current.pos + current.dir,
            dir = current.dir,
          })
        end
      elseif s == "-" then
        if current.dir == V(1, 0) or current.dir == V(-1, 0) then
          local new_dir_1 = current.dir * "L"
          table.insert(queue, {
            pos = current.pos + new_dir_1,
            dir = new_dir_1,
          })
          local new_dir_2 = current.dir * "R"
          table.insert(queue, {
            pos = current.pos + new_dir_2,
            dir = new_dir_2,
          })
        else
          table.insert(queue, {
            pos = current.pos + current.dir,
            dir = current.dir,
          })
        end
      end
    end
  end

  return table.count(points)
end

function M:solve1()
  return self:solver { pos = V(1, 1), dir = V(0, 1) }
end

function M:solve2()
  local max = 0

  for i = 1, #self.input[1] do
    max = math.max(
      max,
      self:solver { pos = V(1, i), dir = V(1, 0) },
      self:solver { pos = V(#self.input, i), dir = V(-1, 0) }
    )
  end

  for i = 1, #self.input do
    max = math.max(
      max,
      self:solver { pos = V(i, 1), dir = V(0, 1) },
      self:solver { pos = V(i, #self.input[1]), dir = V(0, -1) }
    )
  end

  return max
end

M:run()
