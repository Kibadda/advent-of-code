local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "13")

function M:parse(file)
  for line in file:lines() do
    self.input = tonumber(line)
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

function M:solver(end_func)
  local start = { pos = V(1, 1), length = 0 }
  local queue = { start }

  local seen = {}
  seen[("%d|%d"):format(start.pos.x, start.pos.y)] = true
  while #queue > 0 do
    local current = table.remove(queue, 1)

    if end_func(current) then
      return { current = current, seen = seen }
    end

    for _, pos in ipairs(neighbors(current.pos)) do
      local name = ("%d|%d"):format(pos.x, pos.y)
      if not seen[name] and not is_wall(pos, self.input) then
        seen[name] = true

        table.insert(queue, {
          pos = pos,
          length = current.length + 1,
        })
      end
    end
  end
end

function M:solve1()
  self.solution:add(
    "1",
    self:solver(function(current)
      return current.pos == (self.test and V(4, 7) or V(39, 31))
    end).current.length
  )
end

function M:solve2()
  self.solution:add(
    "2",
    table.count(self:solver(function(current)
      return current.length == 50
    end).seen)
  )
end

M:run()

return M
