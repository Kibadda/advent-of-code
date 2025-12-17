--- @class AOCDay201617: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2016", "17")

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
      local doors = MD5.sumhexa(self.input[1] .. current.path):sub(1, 4)
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
  return self:solver(false)
end

function M:solve2()
  return self:solver(true)
end

M:run()
