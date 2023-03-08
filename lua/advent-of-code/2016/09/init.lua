local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "09")

---@param str string
---@param recursive boolean
local function decompress(str, recursive)
  local size = 0
  if str:find "%(" then
    local init = 1
    while true do
      local start_pos, end_pos, length, times = str:find("%((%d+)x(%d+)%)", init)

      if start_pos then
        if init < start_pos then
          size = size + (start_pos - init)
        end

        if recursive then
          size = size + decompress(str:sub(end_pos + 1, end_pos + length), recursive) * times
        else
          size = size + length * times
        end
      else
        size = size + (#str - init + 1)
        break
      end

      init = end_pos + length + 1
    end
  else
    size = #str
  end

  return size
end

function M:solve1()
  self.solution:add("1", decompress(self.input[1], false))
end

function M:solve2()
  self.solution:add("2", decompress(self.input[1], true))
end

M:run(false)

return M
