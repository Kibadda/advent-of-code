local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "13")

function M:parse_input(file)
  for line in file:lines() do
    self.input = line
  end
end

---@param num number
local function to_binary(num)
  local t = {}
  while num > 0 do
    local rest = math.fmod(num, 2)
    table.insert(t, 1, rest)
    num = (num - rest) / 2
  end
  return table.concat(t, "")
end

---@param vector Vector
local function is_wall(vector, input)
  local _, ones = to_binary(
    vector.y * vector.y + 3 * vector.y + 2 * vector.y * vector.x + vector.x + vector.x * vector.x + input
  ):gsub("1", "0")
  return ones % 2 == 1
end

---@param vector Vector
local function neighbors(vector)
  local positions = {
    V(vector.x + 1, vector.y),
    V(vector.x, vector.y + 1),
  }

  if vector.x > 0 then
    positions[#positions + 1] = V(vector.x - 1, vector.y)
  end

  if vector.y > 0 then
    positions[#positions + 1] = V(vector.x, vector.y - 1)
  end

  return positions
end

local function bfs(start, end_func, input)
  start.length = 0
  local queue = { start }

  local seen = {}
  seen[("%d|%d"):format(start.x, start.y)] = true
  while #queue > 0 do
    local current = table.remove(queue, 1)

    if end_func(current) then
      return current, seen
    end

    for _, pos in ipairs(neighbors(current)) do
      local name = ("%d|%d"):format(pos.x, pos.y)
      if not seen[name] and not is_wall(pos, input) then
        seen[name] = true

        pos.length = current.length + 1
        table.insert(queue, pos)
      end
    end
  end
end

function M:solve1(fin)
  local finish = bfs(V(1, 1), function(current)
    return current == fin
  end, tonumber(self.input))
  if not finish then
    return
  end
  self.solution:add("1", finish.length)
end

function M:solve2()
  local _, seen = bfs(V(1, 1), function(current)
    return current.length == 50
  end, tonumber(self.input))
  self.solution:add("2", table.count(seen))
end

M:run(false, { V(4, 7), V(39, 31) })

return M
