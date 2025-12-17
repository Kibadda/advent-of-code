--- @class AOCDay201511: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2015", "11")

--- @param str string
local function check(str)
  local no_i_o_l = str:find "[iol]" == nil

  local has_2_chars = false
  local first_char
  for i = 2, #str do
    if first_char == nil then
      if str:at(i - 1) == str:at(i) then
        first_char = str:at(i)
      end
    else
      if str:at(i - 1) == str:at(i) and str:at(i) ~= first_char then
        has_2_chars = true
        break
      end
    end
  end

  local has_3_consecutive = false
  for i = 3, #str do
    local first = str:at(i - 2):byte()
    local second = str:at(i - 1):byte()
    local third = str:at(i):byte()

    if second - first == 1 and third - second == 1 then
      has_3_consecutive = true
      break
    end
  end

  return no_i_o_l and has_2_chars and has_3_consecutive
end

function M:solver(str)
  repeat
    local t = table.map(str:to_list(), function(c)
      return c:byte()
    end)

    local carry = false
    for i = 8, 1, -1 do
      carry = false

      if t[i] + 1 > 122 then
        carry = true
        t[i] = 97
      else
        t[i] = t[i] + 1
      end

      if not carry then
        break
      end
    end

    str = table.concat(table.map(t, function(num)
      return string.char(num)
    end))
  until check(str)

  return str
end

function M:solve1()
  return self:solver(self.input[1])
end

function M:solve2()
  return self:solver(self.solution["1"])
end

M:run()
