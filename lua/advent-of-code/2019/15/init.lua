--- @class AOCDay201915: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "15")

require "advent-of-code.2019.intcoder"

function M:solve1()
  local map = {}
  local inti = Intcoder(self.input[1]):setup(function(intcoder)
    intcoder.data.pos = V(0, 0)
    intcoder.data.steps = 0

    local input_opcode = intcoder.opcodes[3].func
    intcoder.opcodes[3].func = function(i, ...)
      if #i.input == 0 then
        return IntcoderOpcodesReturnCode.BREAK
      end

      input_opcode(i, ...)
    end

    local output_opcode = intcoder.opcodes[4].func
    intcoder.opcodes[4].func = function(i, ...)
      output_opcode(i, ...)

      --- @type Vector
      local pos = i.data.pos
        + match(i.data.dir) {
          [1] = V(-1, 0),
          [2] = V(1, 0),
          [3] = V(0, -1),
          [4] = V(0, 1),
        }

      match(i.output[#i.output]) {
        [0] = function()
          map[pos.x] = map[pos.x] or {}
          map[pos.x][pos.y] = "#"
        end,
        [1] = function()
          map[pos.x] = map[pos.x] or {}
          map[pos.x][pos.y] = "."
          i.data.pos = pos
          i.data.steps = i.data.steps + 1
        end,
        [2] = function()
          map[pos.x] = map[pos.x] or {}
          map[pos.x][pos.y] = "o"
          i.data.pos = pos
          i.data.steps = i.data.steps + 1
        end,
      }
    end
  end):run()

  --- @type Intcoder
  local result = treesearch {
    depth = false,
    start = inti,
    --- @param current Intcoder
    exit = function(current)
      return current.output[#current.output] == 2
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

  return result.data.steps
end

function M:solve2()
  --
end

M:run()
