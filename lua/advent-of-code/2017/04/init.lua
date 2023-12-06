local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "04")

function M:parse(file)
  self.input = {}
  for line in file:lines() do
    self.input[#self.input + 1] = line:split()
  end
end

function M:solve1()
  local valid = 0
  for _, words in ipairs(self.input) do
    local found = false
    for i, word1 in ipairs(words) do
      for j, word2 in ipairs(words) do
        if i ~= j and word1 == word2 then
          found = true
          break
        end
      end
      if found then
        break
      end
    end
    if not found then
      valid = valid + 1
    end
  end
  self.solution:add("1", valid)
end

function M:solve2()
  local valid = 0
  for _, words in ipairs(self.input) do
    for i, word in ipairs(words) do
      local split = word:to_list()
      table.sort(split)
      words[i] = table.concat(split, "")
    end

    local found = false
    for i, word1 in ipairs(words) do
      for j, word2 in ipairs(words) do
        if i ~= j and word1 == word2 then
          found = true
          break
        end
      end
      if found then
        break
      end
    end
    if not found then
      valid = valid + 1
    end
  end
  self.solution:add("2", valid)
end

M:run()

return M
