local AOC = require "advent-of-code.AOC"
AOC.reload()

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

function M:solver(stop_func)
  local directions = { V(-1, 0), V(1, 0), V(0, -1), V(0, 1) }
  local i = 0
  local input = table.deepcopy(self.input)
  while true do
    i = i + 1
    local proposals = table.frequencies(table.reduce(input, {}, function(carry, v)
      local p = propose(v, directions, input)
      if p then
        table.insert(carry, ("%d|%d"):format(p.x, p.y))
      end
      return carry
    end))
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

  return { i = i, rectangle = (max_x - min_x + 1) * (max_y - min_y + 1) - table.count(input) }
end

function M:solve1()
  self.solution:add(
    "1",
    self:solver(function(i)
      return i == 10
    end).rectangle
  )
end

function M:solve2()
  self.solution:add(
    "2",
    self:solver(function(_, moved)
      return not moved
    end).i
  )
end

M:run()

return M
