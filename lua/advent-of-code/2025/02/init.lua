--- @class AOCDay202502: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2025", "02")

--- @param lines string[]
function M:parse(lines)
  for _, range in ipairs(lines[1]:split ",") do
    local r = range:split "-"
    table.insert(self.input, { tonumber(r[1]), tonumber(r[2]) })
  end
end

function M:solve1()
  local sum = 0

  for _, range in ipairs(self.input) do
    for i = range[1], range[2] do
      local s = tostring(i)

      if #s % 2 == 0 then
        local half = #s / 2
        if s:sub(1, half) == s:sub(half + 1) then
          sum = sum + i
        end
      end
    end
  end

  return sum
end

function M:solve2()
  local sum = 0

  for _, range in ipairs(self.input) do
    for i = range[1], range[2] do
      local s = tostring(i)
      local half = math.floor(#s / 2)

      local is_invalid = false
      for j = 1, half do
        local is_invalid_inner = true

        if #s % j == 0 then
          local word = s:sub(1, j)

          for k = 1, #s, j do
            if s:sub(k, k + j - 1) ~= word then
              is_invalid_inner = false
              break
            end
          end
        else
          is_invalid_inner = false
        end

        if is_invalid_inner then
          is_invalid = true
          break
        end
      end

      if is_invalid then
        sum = sum + i
      end
    end
  end

  return sum
end

M:run()
