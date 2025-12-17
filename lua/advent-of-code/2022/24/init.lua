--- @class AOCDay202224: AOCDay
--- @field input { grid: string[], start_pos: Vector, end_pos: Vector, minutes: number, winds: { up: boolean[][], down: boolean[][], left: boolean[][], right: boolean[][] }[] }
local M = require("advent-of-code.AOCDay"):new("2022", "24")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    grid = lines,
    winds = {},
    minutes = math.huge,
  }

  self.input.start_pos = V(1, assert(self.input.grid[1]:find "%."))
  self.input.end_pos = V(#self.input.grid, assert(self.input.grid[#self.input.grid]:find "%."))

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
  self.input.minutes = rows * cols / math.gcd(rows, cols)
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

--- @param current_position Vector
local function next_moves(input, current_position, minute)
  local moves = {}
  for _, position in ipairs(current_position:adjacent(5)) do
    if
      position.x >= 1
      and position.x <= #input.grid
      and position.y >= 1
      and position.y <= #input.grid[position.x]
      and input.grid[position.x]:at(position.y) ~= "#"
      and not (input.winds[minute].up[position.x] and input.winds[minute].up[position.x][position.y])
      and not (input.winds[minute].down[position.x] and input.winds[minute].down[position.x][position.y])
      and not (input.winds[minute].right[position.x] and input.winds[minute].right[position.x][position.y])
      and not (input.winds[minute].left[position.x] and input.winds[minute].left[position.x][position.y])
    then
      table.insert(moves, position)
    end
  end
  return moves
end

function M:solver(amount)
  local start_pos = self.input.start_pos
  local end_pos = self.input.end_pos
  local solution = {
    minute = 0,
  }
  for i = 1, amount do
    local reverse = i % 2 == 0
    local queue = {
      { pos = start_pos, minute = solution.minute },
    }

    local seen = {}

    while #queue > 0 do
      local current = table.remove(queue, 1)

      local key = ("%d-%d-%d-%s"):format(
        current.minute % self.input.minutes,
        current.pos.x,
        current.pos.y,
        reverse and "r" or "s"
      )
      if not seen[key] then
        seen[key] = true

        local moves = next_moves(self.input, current.pos, current.minute + 1)
        local stop = false
        for _, move in ipairs(moves) do
          if move == end_pos then
            solution = { pos = move, minute = current.minute + 1 }
            stop = true
            break
          end

          table.insert(queue, { pos = move, minute = current.minute + 1 })
        end

        if stop then
          break
        end
      end
    end

    start_pos, end_pos = end_pos, start_pos
  end

  return solution.minute
end

function M:solve1()
  return self:solver(1)
end

function M:solve2()
  return self:solver(3)
end

M:run()
