local AOC = require "advent-of-code.AOC"
AOC.reload()

local md5 = require "advent-of-code.helpers.md5"

local M = AOC.create("2016", "17")

function M:parse_input(file)
  for line in file:lines() do
    self.input = line
  end
end

function M:solver(depth)
  local start = { pos = V(1, 1), path = "" }
  local queue = { start }
  local open = { b = true, c = true, d = true, e = true, f = true }

  local max = -math.huge

  while #queue > 0 do
    local current
    if depth then
      current = table.remove(queue)
    else
      current = table.remove(queue, 1)
    end

    if current.pos == V(4, 4) then
      if depth then
        max = math.max(max, #current.path)
      else
        return current.path
      end
    else
      local doors = md5.sumhexa(self.input .. current.path):sub(1, 4)
      if current.pos.x > 1 and open[doors:at(1)] then
        table.insert(queue, {
          pos = V(current.pos.x - 1, current.pos.y),
          path = current.path .. "U",
        })
      end
      if current.pos.x < 4 and open[doors:at(2)] then
        table.insert(queue, {
          pos = V(current.pos.x + 1, current.pos.y),
          path = current.path .. "D",
        })
      end
      if current.pos.y > 1 and open[doors:at(3)] then
        table.insert(queue, {
          pos = V(current.pos.x, current.pos.y - 1),
          path = current.path .. "L",
        })
      end
      if current.pos.y < 4 and open[doors:at(4)] then
        table.insert(queue, {
          pos = V(current.pos.x, current.pos.y + 1),
          path = current.path .. "R",
        })
      end
    end
  end

  return max
end

function M:solve1()
  self.solution:add("1", self:solver(false))
end

function M:solve2()
  self.solution:add("2", self:solver(true))
end

M:run()

return M
