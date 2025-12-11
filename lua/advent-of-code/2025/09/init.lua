--- @class AOCDay202509: AOCDay
--- @field input Vector[]
local M = require("advent-of-code.AOC").create("2025", "09")

--- @param file file*
function M:parse(file)
  for line in file:lines() do
    local ints = line:only_ints()
    table.insert(self.input, V(ints[2], ints[1]))
  end
end

function M:solve1()
  local max = -math.huge

  for i = 1, #self.input - 1 do
    for j = i + 1, #self.input do
      max =
        math.max(max, math.abs(self.input[i].x - self.input[j].x + 1) * math.abs(self.input[i].y - self.input[j].y + 1))
    end
  end

  return max
end

function M:solve2()
  local edges = {}

  for i = 1, #self.input do
    local j = i == #self.input and 1 or i + 1
    table.insert(edges, {
      self.input[i],
      self.input[j],
      size = math.abs(self.input[i].x - self.input[j].x + 1) * math.abs(self.input[i].y - self.input[j].y + 1),
    })
  end

  table.sort(edges, function(a, b)
    return a.size > b.size
  end)

  local A1 = edges[1][1]
  local A2 = edges[2][2]

  local top_corners = table.filter(self.input, function(c)
    return c.x < A1.x and c.y < A1.y
  end)
  table.sort(top_corners, function(a, b)
    return a.y > b.y
  end)
  top_corners = table.filter(top_corners, function(c)
    return c.x >= top_corners[1].x
  end)
  table.sort(top_corners, function(a, b)
    return a.x > b.x
  end)

  local bot_corners = table.filter(self.input, function(c)
    return c.x > A2.x and c.y < A2.y
  end)
  table.sort(bot_corners, function(a, b)
    return a.y > b.y
  end)
  bot_corners = table.filter(bot_corners, function(c)
    return c.x <= bot_corners[1].x
  end)
  table.sort(bot_corners, function(a, b)
    return a.x < b.x
  end)

  local max = -math.huge
  local y = -math.huge
  for _, corner in ipairs(top_corners) do
    if corner.y > y then
      y = corner.y
      max = math.max(max, (A1.x - corner.x + 1) * (A1.y - corner.y + 1))
    end
  end
  y = -math.huge
  for _, corner in ipairs(bot_corners) do
    if corner.y > y then
      y = corner.y
      max = math.max(max, (corner.x - A2.x + 1) * (A2.y - corner.y + 1))
    end
  end

  return max
end

M:run()
