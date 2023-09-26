local AOC = require "advent-of-code.AOC"
AOC.reload()

local function V(x, y)
  return Vector.new(x, y)
end

local mt = {
  __add = function(v1, v2)
    return V(v1.x + v2.x, v1.y + v2.y)
  end,
  __eq = function(v1, v2)
    return v1.x == v2.x and v1.y == v2.y
  end,
}
Vector = {
  new = function(x, y)
    return setmetatable({
      x = x,
      y = y,
    }, mt)
  end,
  distance = function(v1, v2)
    return math.max(math.abs(v1.x - v2.x), math.abs(v1.y - v2.y))
  end,
}

local M = AOC.create("2022", "23")

function M:parse_input(file)
  local i = 0
  for line in file:lines() do
    i = i + 1
    local j = 0
    for c in line:gmatch "." do
      j = j + 1
      if c == "#" then
        table.insert(self.input, V(i, j))
      end
    end
  end
end

local function find(v, input)
  for _, vec in ipairs(input) do
    if vec == v then
      return true
    end
  end
  return false
end

local function splay(dir)
  return table.map({ -1, 0, 1 }, function(d)
    return V(dir.x == 0 and d or dir.x, dir.y == 0 and d or dir.y)
  end)
end

local function splayed(p, dir)
  return table.map(splay(dir), function(d)
    return p + d
  end)
end

local function eight_adjacent(v)
  return {
    v + V(-1, -1),
    v + V(-1, 0),
    v + V(-1, 1),
    v + V(0, -1),
    v + V(0, 1),
    v + V(1, -1),
    v + V(1, 0),
    v + V(1, 1),
  }
end

local function propose(v, directions, input)
  local alone = table.reduce(eight_adjacent(v), true, function(carry, ve)
    return carry and not find(ve, input)
  end)
  if alone then
    return nil
  end
  for _, dir in ipairs(directions) do
    local free = table.reduce(splayed(v, dir), true, function(carry2, ve)
      return carry2 and not find(ve, input)
    end)
    if free then
      return v + dir
    end
  end
  return nil
end

local function solve(input, stop_func)
  local directions = { V(-1, 0), V(1, 0), V(0, -1), V(0, 1) }
  local i = 0
  while true do
    i = i + 1
    local proposals = table.frequencies(
      table.reduce(input, {}, function(carry, v)
        local p = propose(v, directions, input)
        if p then
          table.insert(carry, p)
        end
        return carry
      end),
      function(s)
        return { ("%d|%d"):format(s.x, s.y), s }
      end
    )
    local next_input = {}
    local moved = false
    for _, elf in ipairs(input) do
      local p = propose(elf, directions, input)
      if p == nil or proposals[("%d|%d"):format(p.x, p.y)] > 1 then
        table.insert(next_input, elf)
      else
        table.insert(next_input, p)
        moved = true
      end
    end

    table.insert(directions, table.remove(directions, 1))
    input = next_input

    if stop_func(i, moved) then
      break
    end
  end

  local min_x, max_x = math.huge, -math.huge
  local min_y, max_y = math.huge, -math.huge
  for _, v in ipairs(input) do
    min_x, max_x = math.min(min_x, v.x), math.max(max_x, v.x)
    min_y, max_y = math.min(min_y, v.y), math.max(max_y, v.y)
  end

  return i, (max_x - min_x + 1) * (max_y - min_y + 1) - table.count(input)
end

function M:solve1()
  local _, rectangle = solve(table.deepcopy(self.input), function(i)
    return i == 10
  end)
  self.solution:add("1", rectangle)
end

function M:solve2()
  local i = solve(table.deepcopy(self.input), function(_, moved)
    return not moved
  end)
  self.solution:add("2", i)
end

M:run()

return M
