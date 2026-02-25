--- @class AOCDay202403: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2024", "03")

function M:solve1()
  return table.reduce(self.input, 0, function(sum, line)
    local index = 1

    while true do
      local s, e, first, second = line:find("mul%((%d?%d?%d),(%d?%d?%d)%)", index)

      if not s or not e then
        break
      end

      index = e

      sum = sum + tonumber(first) * tonumber(second)
    end

    return sum
  end)
end

function M:solve2()
  local is_enabled = true

  return table.reduce(self.input, 0, function(sum, line)
    local index = 1

    while true do
      local do_s, do_e = line:find("do%(%)", index)
      local dont_s, dont_e = line:find("don't%(%)", index)
      local s, e, first, second = line:find("mul%((%d?%d?%d),(%d?%d?%d)%)", index)

      if (not do_s or not do_e) and (not dont_s or not dont_e) and (not s or not e) then
        break
      end

      do_s = do_s or math.huge
      dont_s = dont_s or math.huge
      s = s or math.huge

      if do_s < dont_s and do_s < s then
        is_enabled = true
        index = assert(do_e)
      elseif dont_s < do_s and dont_s < s then
        is_enabled = false
        index = assert(dont_e)
      elseif is_enabled then
        sum = sum + tonumber(first) * tonumber(second)
        index = assert(e)
      else
        index = assert(e)
      end
    end

    return sum
  end)
end

M:run()
