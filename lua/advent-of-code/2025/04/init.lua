--- @class AOCDay202504: AOCDay
--- @field input string[][]
local M = require("advent-of-code.AOC").create("2025", "04")

function M:parse(file)
  for line in file:lines() do
    table.insert(self.input, line:to_list())
  end
end

function M:solver(input)
  local copy = table.deepcopy(input)

  local forklifts = 0

  for i, row in ipairs(input) do
    for j, col in ipairs(row) do
      if col == "@" then
        local v = V(i, j)

        local paper = 0
        for _, a in ipairs(v:adjacent(8)) do
          if input[a.x] and input[a.x][a.y] and input[a.x][a.y] == "@" then
            paper = paper + 1
          end
        end

        if paper < 4 then
          forklifts = forklifts + 1
          copy[v.x][v.y] = "."
        end
      end
    end
  end

  return forklifts, copy
end

function M:solve1()
  return self:solver(self.input)
end

function M:solve2()
  local sum = 0
  local input = self.input
  local forklifts = 0

  while true do
    forklifts, input = self:solver(input)

    if forklifts == 0 then
      break
    end

    sum = sum + forklifts
  end

  return sum
end

M:run()
