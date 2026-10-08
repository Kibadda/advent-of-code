--- @class AOCDay201915: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "15")

require "advent-of-code.2019.intcoder"

local map = {}
local oxygen = V(0, 0)

function M:solve1()
  local distance = 0

  local inti = Intcoder(self.input[1]):on_output(function(output, intcoder)
    --- @type Vector
    local pos = intcoder.data.pos
      + match(intcoder.data.dir) {
        [1] = V(-1, 0),
        [2] = V(1, 0),
        [3] = V(0, -1),
        [4] = V(0, 1),
      }

    match(output) {
      [0] = function()
        map[pos.x] = map[pos.x] or {}
        map[pos.x][pos.y] = "#"
      end,
      [1] = function()
        map[pos.x] = map[pos.x] or {}
        map[pos.x][pos.y] = "."
        intcoder.data.pos = pos
        intcoder.data.steps = intcoder.data.steps + 1
      end,
      [2] = function()
        map[pos.x] = map[pos.x] or {}
        map[pos.x][pos.y] = "o"
        intcoder.data.pos = pos
        intcoder.data.steps = intcoder.data.steps + 1
        distance = intcoder.data.steps
        oxygen = pos
      end,
    }
  end):run {
    data = {
      pos = V(0, 0),
      steps = 0,
    },
  }

  treesearch {
    depth = false,
    start = inti,
    exit = function()
      return false
    end,
    --- @param current Intcoder
    memoize = function(current)
      return current.data.pos:string()
    end,
    --- @param current Intcoder
    step = function(current)
      local steps = {}

      for i = 1, 4 do
        local pos = current.data.pos
          + match(i) {
            [1] = V(-1, 0),
            [2] = V(1, 0),
            [3] = V(0, -1),
            [4] = V(0, 1),
          }

        if not map[pos.x] or map[pos.x][pos.y] ~= "#" then
          local copy = table.deepcopy(current)
          copy.data.dir = i
          table.insert(copy.input, i)
          copy:run()
          table.insert(steps, copy)
        end
      end

      return steps
    end,
  }

  -- local min = math.huge
  -- local max = -math.huge
  -- for _, row in spairs(map) do
  --   local keys = table.keys(row)
  --   table.sort(keys)
  --   min = math.min(min, keys[1])
  --   max = math.max(max, keys[#keys])
  -- end
  --
  -- for i, row in spairs(map) do
  --   for k = min, max do
  --     row[k] = row[k] or " "
  --   end
  --
  --   local s = ""
  --   for j, c in spairs(row) do
  --     if i == 0 and j == 0 then
  --       s = s .. "Q"
  --     else
  --       s = s .. c
  --     end
  --   end
  --   print(s)
  -- end

  return distance
end

function M:solve2()
  local minutes = 0

  treesearch {
    depth = false,
    start = { pos = oxygen, minutes = 0 },
    --- @param current { pos: Vector, minutes: integer }
    exit = function(current)
      minutes = current.minutes

      return false
    end,
    --- @param current { pos: Vector, minutes: integer }
    memoize = function(current)
      return current.pos:string()
    end,
    --- @param current { pos: Vector, minutes: integer }
    step = function(current)
      local steps = {}

      for i = 1, 4 do
        local pos = current.pos
          + match(i) {
            [1] = V(-1, 0),
            [2] = V(1, 0),
            [3] = V(0, -1),
            [4] = V(0, 1),
          }

        if map[pos.x] and map[pos.x][pos.y] == "." then
          table.insert(steps, {
            pos = pos,
            minutes = current.minutes + 1,
          })
        end
      end

      return steps
    end,
  }

  return minutes
end

M:run()
