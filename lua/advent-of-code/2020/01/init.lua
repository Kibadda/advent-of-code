--- @class AOCDay202001: AOCDay
--- @field input integer[]
local M = require("advent-of-code.AOCDay"):new("2020", "01")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    table.insert(self.input, tonumber(line))
  end
end

function M:solve1()
  for _, i in ipairs(self.input) do
    for _, j in ipairs(self.input) do
      if i + j == 2020 then
        print(i, j)
        return i * j
      end
    end
  end
end

function M:solve2()
  for _, i in ipairs(self.input) do
    for _, j in ipairs(self.input) do
      for _, k in ipairs(self.input) do
        if i + j + k == 2020 then
          return i * j * k
        end
      end
    end
  end
end

M:run()
