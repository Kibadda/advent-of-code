local AOCDay = require "advent-of-code.AOCDay"

local astar = require "advent-of-code.2022.12.a-star"

local M = AOCDay:new("2022", "12")

function M:parse_input()
  local nodes = {}
  local start_pos
  local end_pos

  for i, line in ipairs(self.lines) do
    for j, c in ipairs(line:to_list()) do
      if c == "S" then
        start_pos = { x = i, y = j, c = "a" }
        table.insert(nodes, start_pos)
      elseif c == "E" then
        end_pos = { x = i, y = j, c = "z" }
        table.insert(nodes, end_pos)
      else
        table.insert(nodes, { x = i, y = j, c = c })
      end
    end
  end

  return {
    nodes = nodes,
    start_pos = start_pos,
    end_pos = end_pos,
  }
end

function M:solve1()
  local parsed = self:parse_input()
  local path = astar.path(parsed.end_pos, parsed.start_pos, parsed.nodes, true, function(node, neighbor)
    return node.c:byte() - neighbor.c:byte() < 2
      and (node.x == neighbor.x or node.y == neighbor.y)
      and math.abs(node.x - neighbor.x) <= 1
      and math.abs(node.y - neighbor.y) <= 1
  end)

  return #path - 1
end

function M:solve2()
  local parsed = self:parse_input()
  local filtered = {}
  for _, node in ipairs(parsed.nodes) do
    if node.c == "a" then
      table.insert(filtered, node)
    end
  end
  local min_path = math.huge
  for _, node in ipairs(filtered) do
    local path = astar.path(parsed.end_pos, node, parsed.nodes, true, function(cur_node, neighbor)
      return cur_node.c:byte() - neighbor.c:byte() < 2
        and (cur_node.x == neighbor.x or cur_node.y == neighbor.y)
        and math.abs(cur_node.x - neighbor.x) <= 1
        and math.abs(cur_node.y - neighbor.y) <= 1
    end)

    if path ~= nil then
      min_path = math.min(min_path, #path - 1)
    end
  end

  return min_path
end

-- function table.find(t, pos)
--   for i, p in ipairs(t) do
--     if p.x == pos.x and p.y == pos.y then
--       return i
--     end
--   end

--   return nil
-- end

-- function M:solve1()
--   local parsed = self:parse_input()

--   local seen = { parsed.end_pos }

--   local steps = 0
--   local current_pos = {
--     x = parsed.end_pos.x,
--     y = parsed.end_pos.y,
--   }

--   local function get_next_pos()
--     local cur_char = parsed.grid[current_pos.x][current_pos.y]:byte()
--     local new_positions = {
--       top = nil,
--       right = nil,
--       bottom = nil,
--       left = nil,
--     }
--     if current_pos.x > 1 and cur_char - parsed.grid[current_pos.x - 1][current_pos.y]:byte() < 2 then
--       new_positions.top = { x = current_pos.x - 1, y = current_pos.y }
--     end
--     if
--       current_pos.y < #parsed.grid[current_pos.x]
--       and cur_char - parsed.grid[current_pos.x][current_pos.y + 1]:byte() < 2
--     then
--       new_positions.right = { x = current_pos.x, y = current_pos.y + 1 }
--     end
--     if current_pos.x < #parsed.grid and cur_char - parsed.grid[current_pos.x + 1][current_pos.y]:byte() < 2 then
--       new_positions.bottom = { x = current_pos.x + 1, y = current_pos.y }
--     end
--     if current_pos.y > 1 and cur_char - parsed.grid[current_pos.x][current_pos.y - 1]:byte() < 2 then
--       new_positions.left = { x = current_pos.x, y = current_pos.y - 1 }
--     end

--     -- local min_distance_pos
--     -- local min = math.huge
--     for _, pos in pairs(new_positions) do
--       -- if table.find(seen, pos) == nil then
--       --   local distance = math.sqrt(
--       --     math.pow(math.abs(parsed.start_pos.x - pos.x), 2) + math.pow(math.abs(parsed.start_pos.y - pos.y), 2)
--       --   )
--       --   if distance < min then
--       --     min = distance
--       --     min_distance_pos = pos
--       --   end
--       -- end
--       if table.find(seen, pos) == nil then
--         return pos
--       end
--     end

--     return nil
--   end

--   while current_pos.x ~= parsed.start_pos.x or current_pos.y ~= parsed.start_pos.y do
--     local next_pos = get_next_pos()

--     if next_pos == nil then
--       current_pos = seen[table.find(seen, current_pos) - 1]
--     else
--       table.insert(seen, next_pos)
--       steps = steps + 1
--       current_pos = next_pos
--     end

--     if steps > 10000 then
--       break
--     end
--   end

--   return steps
-- end

return M
