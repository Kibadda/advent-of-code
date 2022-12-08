local AOCDay = require "advent-of-code.AOCDay"

local M = AOCDay:new("2022", "08")

function M:parse_input()
  local grid = {}

  for i, line in ipairs(self.lines) do
    table.insert(grid, {})
    for c in line:gmatch "." do
      table.insert(grid[i], c)
    end
  end

  return grid
end

function M:solve1()
  local visible_trees = 0

  local grid = self:parse_input()

  for i, row in ipairs(grid) do
    for j, col in ipairs(row) do
      if i == 1 or j == 1 or i == #grid or j == #grid[i] then
        visible_trees = visible_trees + 1
      else
        -- top
        local visible_top = true
        for k = i - 1, 1, -1 do
          if grid[k][j] >= col then
            visible_top = false
            break
          end
        end
        -- right
        local visible_right = true
        for k = j + 1, #grid[i] do
          if grid[i][k] >= col then
            visible_right = false
            break
          end
        end
        -- bottom
        local visible_bottom = true
        for k = i + 1, #grid do
          if grid[k][j] >= col then
            visible_bottom = false
            break
          end
        end
        -- left
        local visible_left = true
        for k = j - 1, 1, -1 do
          if grid[i][k] >= col then
            visible_left = false
            break
          end
        end

        if visible_top or visible_right or visible_bottom or visible_left then
          visible_trees = visible_trees + 1
        end
      end
    end
  end

  return visible_trees
end

function M:solve2()
  local max_scenic_score = 0

  local grid = self:parse_input()

  for i, row in ipairs(grid) do
    for j, col in ipairs(row) do
      -- top
      local visible_top = 0
      for k = i - 1, 1, -1 do
        visible_top = visible_top + 1
        if grid[k][j] >= col then
          break
        end
      end
      -- right
      local visible_right = 0
      for k = j + 1, #grid[i] do
        visible_right = visible_right + 1
        if grid[i][k] >= col then
          break
        end
      end
      -- bottom
      local visible_bottom = 0
      for k = i + 1, #grid do
        visible_bottom = visible_bottom + 1
        if grid[k][j] >= col then
          break
        end
      end
      -- left
      local visible_left = 0
      for k = j - 1, 1, -1 do
        visible_left = visible_left + 1
        if grid[i][k] >= col then
          break
        end
      end

      max_scenic_score = math.max(max_scenic_score, visible_top * visible_right * visible_bottom * visible_left)
    end
  end

  return max_scenic_score
end

return M
