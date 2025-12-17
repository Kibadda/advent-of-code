--- @class AOCDay201704: AOCDay
--- @field input string[][]
local M = require("advent-of-code.AOCDay"):new("2017", "04")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, line:split())
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
  return valid
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
  return valid
end

M:run()
