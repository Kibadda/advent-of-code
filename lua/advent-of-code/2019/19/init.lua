--- @class AOCDay201919: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "19")

require "advent-of-code.2019.intcoder"

function M:solver(i, j)
  return Intcoder(self.input[1])
    :setup(function(intcoder)
      intcoder.input = { i, j }
    end)
    :run().output[1]
end

function M:solve1()
  local affected = 0

  for i = 0, 49 do
    for j = 0, 49 do
      affected = affected + self:solver(i, j)
    end
  end

  return affected
end

function M:solve2()
  local cache = setmetatable({}, {
    __index = function()
      return {}
    end,
  })

  local function key(i, j)
    return ("%s|%s"):format(i, j)
  end

  local i = 5
  local j = 4
  local j_start = 0
  local found_beam = false
  while true do
    local result = self:solver(i, j)

    local height = (cache[key(i - 1, j)][1] or 0) + result
    local width = (cache[key(i, j - 1)][2] or 0) + result

    if height >= 100 and width >= 100 then
      break
    end

    cache[key(i, j)] = { height, width }

    if result == 1 then
      if not found_beam then
        j_start = j
        j = j + 1
        found_beam = true
      else
        j = j + 1
      end
    else
      if not found_beam then
        j = j + 1
      else
        i = i + 1
        j = j_start
        found_beam = false
      end
    end
  end

  return (i - 99) * 10000 + (j - 99)
end

M:run()
