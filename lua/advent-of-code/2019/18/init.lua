--- @class AOCDay201918: AOCDay
--- @field input { grid: string[][], keys: table<string, { pos: Vector, door: Vector }>, pos: Vector }
local M = require("advent-of-code.AOCDay"):new("2019", "18")

local a_byte = string.byte "a"
local z_byte = string.byte "z"
local A_byte = string.byte "A"
local Z_byte = string.byte "Z"

--- @param lines string[]
function M:parse(lines)
  self.input = {
    grid = {},
    keys = {},
  }

  local doors = {}

  for i, line in ipairs(lines) do
    self.input.grid[i] = line:to_list()

    for j, c in ipairs(self.input.grid[i]) do
      local b = c:byte()
      if b >= a_byte and b <= z_byte then
        self.input.keys[c] = {
          pos = V(i, j),
        }
      elseif b >= A_byte and b <= Z_byte then
        doors[c:lower()] = V(i, j)
      elseif c == "@" then
        self.input.pos = V(i, j)
      end
    end
  end

  for door, pos in pairs(doors) do
    self.input.keys[door].door = pos
  end
end

function M:solve1()
  print(os.date "%H:%M:%S")

  return treesearch {
    depth = true,
    bound = 5030, -- 4930
    start = {
      grid = table.deepcopy(self.input.grid),
      pos = V(self.input.pos.x, self.input.pos.y),
      keys = table.deepcopy(self.input.keys),
      steps = 0,
    },
    --- @param current { grid: string[][], pos: Vector, keys: table<string, { pos: Vector, door: Vector }>, steps: integer }
    exit = function(current)
      return table.count(current.keys) == 0
    end,
    --- @param solution integer
    --- @param current { grid: string[][], pos: Vector, keys: table<string, { pos: Vector, door: Vector }>, steps: integer }
    compare = function(solution, current)
      if current.steps < solution then
        print(current.steps, os.date "%H:%M:%S")
        return current.steps
      end

      return solution
    end,
    --- @param current { grid: string[][], pos: Vector, keys: table<string, { pos: Vector, door: Vector }>, steps: integer }
    memoize = function(current)
      local keys = table.keys(current.keys)
      table.sort(keys)

      return ("%s-%s"):format(table.concat(keys, ","), current.pos:string()), current.steps
    end,
    --- @param current { grid: string[][], pos: Vector, keys: table<string, { pos: Vector, door: Vector }>, steps: integer }
    --- @param solution integer
    step = function(current, solution)
      local steps = {}

      local _, d = next(current.keys)
      if current.steps + current.pos:distance(d.pos) >= solution then
        return steps
      end

      for _, pos in ipairs(current.pos:adjacent(4)) do
        local c = current.grid[pos.x] and current.grid[pos.x][pos.y] or nil

        if c ~= "#" and not (c:byte() >= A_byte and c:byte() <= Z_byte) then
          local next = table.deepcopy(current)
          next.steps = next.steps + 1
          next.pos = pos

          if c:byte() >= a_byte and c:byte() <= z_byte then
            next.grid[pos.x][pos.y] = "."
            next.keys[c] = nil
            if self.input.keys[c].door then
              next.grid[self.input.keys[c].door.x][self.input.keys[c].door.y] = "."
            end
          end

          table.insert(steps, next)
        end
      end

      return steps
    end,
  }
  --- too high: 5030
end

function M:solve2()
  --
end

M:run()
