--- @class AOCDay201606: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2016", "06")

function M:solver(last_or_first)
  local frequencies = {}
  for _, line in ipairs(self.input) do
    for i, c in ipairs(line:to_list()) do
      frequencies[i] = frequencies[i] or {}

      frequencies[i][c] = (frequencies[i][c] or 0) + 1
    end
  end
  local word = ""
  for i, pos in ipairs(frequencies) do
    local sorted = {}
    for k, v in pairs(pos) do
      sorted[#sorted + 1] = v .. k
    end
    table.sort(sorted)
    frequencies[i] = sorted
    word = word .. sorted[last_or_first == "first" and 1 or #sorted]:at(-1)
  end
  return word
end

function M:solve1()
  return self:solver "last"
end

function M:solve2()
  return self:solver "first"
end

M:run()
