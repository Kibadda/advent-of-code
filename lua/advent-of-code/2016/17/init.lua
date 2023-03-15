local AOC = require "advent-of-code.AOC"
AOC.reload()

local md5 = require "advent-of-code.helpers.md5"

local M = AOC.create("2016", "17")

function M:parse_input(file)
  for line in file:lines() do
    self.input = line
  end
end

local function bfs(start, finish, input)
  start.path = ""
  local queue = { start }
  local open = { b = true, c = true, d = true, e = true, f = true }

  while #queue > 0 do
    local current = table.remove(queue, 1)

    if current == finish then
      return current.path
    end

    local doors = md5.sumhexa(input .. current.path):sub(1, 4)
    if current.x > 1 and open[doors:at(1)] then
      local up = V(current.x - 1, current.y)
      up.path = current.path .. "U"
      table.insert(queue, up)
    end
    if current.x < 4 and open[doors:at(2)] then
      local down = V(current.x + 1, current.y)
      down.path = current.path .. "D"
      table.insert(queue, down)
    end
    if current.y > 1 and open[doors:at(3)] then
      local left = V(current.x, current.y - 1)
      left.path = current.path .. "L"
      table.insert(queue, left)
    end
    if current.y < 4 and open[doors:at(4)] then
      local right = V(current.x, current.y + 1)
      right.path = current.path .. "R"
      table.insert(queue, right)
    end
  end
end

function M:solve1()
  self.solution:add("1", bfs(V(1, 1), V(4, 4), self.input))
end

local function dfs(start, finish, input)
  start.path = ""
  local queue = { start }
  local open = { b = true, c = true, d = true, e = true, f = true }

  local max = 0

  while #queue > 0 do
    local current = table.remove(queue)

    if current == finish then
      max = math.max(max, #current.path)
    else
      local doors = md5.sumhexa(input .. current.path):sub(1, 4)
      if current.x > 1 and open[doors:at(1)] then
        local up = V(current.x - 1, current.y)
        up.path = current.path .. "U"
        table.insert(queue, up)
      end
      if current.x < 4 and open[doors:at(2)] then
        local down = V(current.x + 1, current.y)
        down.path = current.path .. "D"
        table.insert(queue, down)
      end
      if current.y > 1 and open[doors:at(3)] then
        local left = V(current.x, current.y - 1)
        left.path = current.path .. "L"
        table.insert(queue, left)
      end
      if current.y < 4 and open[doors:at(4)] then
        local right = V(current.x, current.y + 1)
        right.path = current.path .. "R"
        table.insert(queue, right)
      end
    end
  end

  return max
end

function M:solve2()
  self.solution:add("2", dfs(V(1, 1), V(4, 4), self.input))
end

M:run(false)

return M
