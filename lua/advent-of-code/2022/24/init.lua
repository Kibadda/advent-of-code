local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "24")

local function gcd(a, b)
  if a == b then
    return a
  elseif a < b then
    return gcd(a, b - a)
  elseif a > b then
    return gcd(a - b, b)
  end
end

function M:parse_input(file)
  self.input = {
    grid = {},
    winds = {},
    minutes = math.huge,
    start_pos = nil,
    end_pos = nil,
  }

  for line in file:lines() do
    table.insert(self.input.grid, line)
  end

  self.input.start_pos = V(1, self.input.grid[1]:find "%.")
  self.input.end_pos = V(#self.input.grid, self.input.grid[#self.input.grid]:find "%.")

  local up, down, right, left = {}, {}, {}, {}

  for i, row in ipairs(self.input.grid) do
    local j = 0
    for c in row:gmatch "." do
      j = j + 1
      match(c) {
        ["^"] = function()
          up[i] = up[i] or {}
          up[i][j] = true
        end,
        ["v"] = function()
          down[i] = down[i] or {}
          down[i][j] = true
        end,
        [">"] = function()
          right[i] = right[i] or {}
          right[i][j] = true
        end,
        ["<"] = function()
          left[i] = left[i] or {}
          left[i][j] = true
        end,
      }
    end
  end

  local rows = #self.input.grid - 2
  local cols = #self.input.grid[1] - 2
  self.input.minutes = rows * cols / gcd(rows, cols)
  for i = 0, self.input.minutes - 1 do
    self.input.winds[i] = {
      up = {},
      down = {},
      right = {},
      left = {},
    }

    for j, winds in pairs(up) do
      local index = j - i
      while index <= 1 do
        index = index + rows
      end
      self.input.winds[i].up[index] = winds
    end

    for j, winds in pairs(down) do
      local index = j + i
      while index > rows + 1 do
        index = index - rows
      end
      self.input.winds[i].down[index] = winds
    end

    for j, winds in pairs(right) do
      self.input.winds[i].right[j] = {}
      for k, wind in pairs(winds) do
        local index = k + i
        while index > cols + 1 do
          index = index - cols
        end
        self.input.winds[i].right[j][index] = wind
      end
    end

    for j, winds in pairs(left) do
      self.input.winds[i].left[j] = {}
      for k, wind in pairs(winds) do
        local index = k - i
        while index <= 1 do
          index = index + cols
        end
        self.input.winds[i].left[j][index] = wind
      end
    end
  end

  setmetatable(self.input.winds, {
    __index = function(winds, minute)
      return winds[minute % self.input.minutes]
    end,
  })
end

function M:enc(position, minute, reverse)
  return ("%d-%d-%d-%s"):format(minute % self.input.minutes, position.x, position.y, reverse and "r" or "s")
end

local results = {}
function M:next_moves(current_position, minute, reverse)
  local k = self:enc(current_position, minute, reverse)
  if results[k] then
    if reverse then
      return table.reverse(results[k])
    else
      return results[k]
    end
  else
    local positions
    if reverse then
      positions = {
        current_position + V(-1, 0),
        current_position + V(0, -1),
        current_position + V(1, 0),
        current_position + V(0, 1),
        current_position,
      }
    else
      positions = {
        current_position + V(1, 0),
        current_position + V(0, 1),
        current_position + V(-1, 0),
        current_position + V(0, -1),
        current_position,
      }
    end

    local moves = {}
    for _, position in ipairs(positions) do
      if
        position.x >= 1
        and position.x <= #self.input.grid
        and position.y >= 1
        and position.y <= #self.input.grid[position.x]
        and self.input.grid[position.x]:at(position.y) ~= "#"
        and not (self.input.winds[minute].up[position.x] and self.input.winds[minute].up[position.x][position.y])
        and not (self.input.winds[minute].down[position.x] and self.input.winds[minute].down[position.x][position.y])
        and not (self.input.winds[minute].right[position.x] and self.input.winds[minute].right[position.x][position.y])
        and not (self.input.winds[minute].left[position.x] and self.input.winds[minute].left[position.x][position.y])
      then
        table.insert(moves, position)
      end
    end
    results[k] = moves
    return moves
  end
end

function M:bfs(minute, reverse, start_pos, end_pos)
  local queue = {
    {
      pos = start_pos,
      minute = minute,
    },
  }

  local seen = {}

  while #queue > 0 do
    local current = table.remove(queue, 1)

    if not seen[self:enc(current.pos, current.minute, reverse)] then
      local next_minute = current.minute + 1

      seen[self:enc(current.pos, current.minute, reverse)] = true

      local moves = self:next_moves(current.pos, next_minute, reverse)
      for _, move in ipairs(moves) do
        if move == end_pos then
          return {
            pos = move,
            minute = next_minute,
          }
        end

        table.insert(queue, {
          pos = move,
          minute = next_minute,
        })
      end
    end
  end
end

function M:solver(amount)
  local solution = {
    minute = 0,
  }

  local start_pos, end_pos = self.input.start_pos, self.input.end_pos

  for i = 1, amount do
    solution = self:bfs(solution.minute, i % 2 == 0, start_pos, end_pos)
    start_pos, end_pos = end_pos, start_pos
    print(table.to_string(solution))
  end

  return solution.minute
end

function M:solve1()
  -- 301
  self.solution:add("1", self:solver(1))
end

function M:solve2()
  self.solution:add("2", self:solver(3))
end

M:run()

return M
