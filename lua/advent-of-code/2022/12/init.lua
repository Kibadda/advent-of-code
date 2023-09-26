local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "12")

local start_pos
local end_pos

function M:parse_input(file)
  local i = 0
  for line in file:lines() do
    i = i + 1
    for j, c in ipairs(line:to_list()) do
      if c == "S" then
        start_pos = { x = i, y = j, c = "a" }
        table.insert(self.input, start_pos)
      elseif c == "E" then
        end_pos = { x = i, y = j, c = "z" }
        table.insert(self.input, end_pos)
      else
        table.insert(self.input, { x = i, y = j, c = c })
      end
    end
  end
end

local function count_steps(node)
  if node.parent then
    return 1 + count_steps(node.parent)
  else
    return 1
  end
end

local function bfs(nodes, start, end_func)
  local queue = { start }
  local seen = { start }

  while #queue > 0 do
    local current = table.remove(queue, 1)
    if end_func(current) then
      return current
    end
    for _, node in ipairs(nodes) do
      if
        current.c:byte() - node.c:byte() < 2
        and (node.x == current.x or node.y == current.y)
        and math.abs(node.x - current.x) <= 1
        and math.abs(node.y - current.y) <= 1
      then
        if table.find(seen, node) == nil then
          table.insert(seen, node)
          node.parent = current
          table.insert(queue, node)
        end
      end
    end
  end

  return math.huge
end

function M:solve1()
  local current = bfs(self.input, end_pos, function(node)
    return node.x == start_pos.x and node.y == start_pos.y
  end)

  self.solution:add("1", count_steps(current) - 1)
end

function M:solve2()
  local current = bfs(self.input, end_pos, function(node)
    return node.c == "a"
  end)

  self.solution:add("2", count_steps(current) - 1)
end

M:run()

return M
