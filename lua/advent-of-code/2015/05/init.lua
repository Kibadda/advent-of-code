local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "05")

function M:solve1()
  local amount = 0

  for _, line in ipairs(self.input) do
    local count_vowels = 0
    local has_double = false
    local has_no_banned_pairs = true
    local vowels = { a = 1, e = 1, i = 1, o = 1, u = 1 }
    local banned_pairs = { ab = 1, cd = 1, pq = 1, xy = 1 }
    for i = 1, #line - 1 do
      local pair = line:sub(i, i + 1)
      if vowels[pair:sub(1, 1)] ~= nil then
        count_vowels = count_vowels + 1
      end
      if banned_pairs[pair] ~= nil then
        has_no_banned_pairs = false
      end
      if pair:sub(1, 1) == pair:sub(2, 2) then
        has_double = true
      end
    end

    if vowels[line:sub(#line, #line)] ~= nil then
      count_vowels = count_vowels + 1
    end

    if count_vowels >= 3 and has_double and has_no_banned_pairs then
      amount = amount + 1
    end
  end

  self.solution:add("one", amount)
end

function M:solve2()
  local amount = 0

  for _, line in ipairs(self.input) do
    local has_double = false
    local has_pair = false
    for i = 1, #line - 1 do
      local window = line:sub(i, i + 1)
      local one = window:sub(1, 1)
      local two = window:sub(2, 2)
      if i > 1 then
        if line:sub(i - 1, i - 1) == two and one ~= two then
          has_pair = true
        end
      end

      if line:match(window, i + 2) then
        has_double = true
      end
    end

    if has_double and has_pair then
      amount = amount + 1
    end
  end

  self.solution:add("two", amount)
end

M:run(false)

return M
