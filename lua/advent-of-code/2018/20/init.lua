--- @class AOCDay201820: AOCDay
--- @field input any
local M = require("advent-of-code.AOCDay"):new("2018", "20")

--- @param lines string[]
function M:parse(lines)
  local current = { pos = V(0, 0), dist = 0 }
  local stack = { current }
  self.input = {}

  --- @param d Vector
  local function add(d)
    local dx = current.pos.x + d.x
    local dy = current.pos.y + d.y
    local node = self.input[dx] and self.input[dx][dy] or { pos = V(dx, dy), dist = math.huge }
    node.dist = math.min(node.dist, current.dist + 1)
    current = node
    self.input[node.pos.x] = self.input[node.pos.x] or {}
    self.input[node.pos.x][node.pos.y] = node
  end

  for _, c in ipairs(lines[1]:sub(2, -2):to_list()) do
    match(c) {
      N = function()
        add(V(0, -1))
      end,
      S = function()
        add(V(0, 1))
      end,
      E = function()
        add(V(1, 0))
      end,
      W = function()
        add(V(-1, 0))
      end,
      ["("] = function()
        table.insert(stack, current)
      end,
      [")"] = function()
        current = table.remove(stack)
      end,
      ["|"] = function()
        current = stack[#stack]
      end,
    }
  end
end

function M:solve1()
  local dist = 0

  for _, row in pairs(self.input) do
    for _, c in pairs(row) do
      dist = math.max(dist, c.dist)
    end
  end

  return dist
end

function M:solve2()
  local number = 0

  for _, row in pairs(self.input) do
    for _, c in pairs(row) do
      number = number + (c.dist >= 1000 and 1 or 0)
    end
  end

  return number
end

M:run()
