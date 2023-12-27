local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay202317: AOCDay
---@field input string[]
local M = AOC.create("2023", "17")

function M:solver(valid)
  local queue = {
    [0] = {
      { loss = 0, pos = V(1, 1), dir = V(0, 0), consecutive = -1 },
    },
  }
  local seen = {}

  local function find()
    for i = 0, 100000 do
      if queue[i] then
        if #queue[i] == 1 then
          local r = queue[i][1]
          queue[i] = nil
          return r
        else
          return table.remove(queue[i], 1)
        end
      end
    end

    return nil
  end

  ---@type { loss: integer, pos: Vector, dir: Vector, consecutive: integer }?
  local current = find()
  while current do
    local key = ("%d|%d|%d|%d|%d"):format(
      current.pos.x,
      current.pos.y,
      current.dir.x,
      current.dir.y,
      current.consecutive
    )

    if not seen[key] then
      seen[key] = current.loss

      for _, dir in ipairs { V(-1, 0), V(0, 1), V(1, 0), V(0, -1) } do
        local new_consecutive = dir ~= current.dir and 1 or current.consecutive + 1
        local new_pos = current.pos + dir

        local reverse = (current.dir == V(1, 0) and dir == V(-1, 0))
          or (current.dir == V(-1, 0) and dir == V(1, 0))
          or (current.dir == V(0, 1) and dir == V(0, -1))
          or (current.dir == V(0, -1) and dir == V(0, 1))

        if
          new_pos.x >= 1
          and new_pos.x <= #self.input
          and new_pos.y >= 1
          and new_pos.y <= #self.input[1]
          and not reverse
          and valid(new_consecutive, dir, current.dir, current.consecutive)
        then
          local loss = current.loss + self.input[new_pos.x]:at(new_pos.y)
          queue[loss] = queue[loss] or {}
          table.insert(queue[loss], {
            loss = loss,
            pos = new_pos,
            dir = dir,
            consecutive = new_consecutive,
          })
        end
      end
    end

    current = find()
  end

  local min = math.huge

  for key, loss in pairs(seen) do
    local row, col = unpack(key:only_ints())
    if row == #self.input and col == #self.input[1] then
      min = math.min(min, loss)
    end
  end

  return min
end

function M:solve1()
  return self:solver(function(new_consecutive)
    return new_consecutive <= 3
  end)
end

function M:solve2()
  return self:solver(function(new_consecutive, new_dir, dir, consecutive)
    return new_consecutive <= 10 and (new_dir == dir or consecutive >= 4 or consecutive == -1)
  end)
end

M:run()

return M
