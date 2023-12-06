local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "08")

function M:parse(file)
  for line in file:lines() do
    local split = line:split()
    local ints = line:only_ints()
    table.insert(
      self.input,
      match(split[1]) {
        rect = function()
          return { cmd = "create", a = ints[1], b = ints[2] }
        end,
        rotate = function()
          return { cmd = split[2], a = ints[1], b = ints[2] }
        end,
      }
    )
  end
end

function M:solver()
  local grid = {}
  for _, instruction in ipairs(self.input) do
    match(instruction.cmd) {
      create = function()
        for i = 1, instruction.b do
          for j = 1, instruction.a do
            if not table.find(grid, { x = i - 1, y = j - 1 }) then
              table.insert(grid, V(i - 1, j - 1))
            end
          end
        end
      end,
      column = function()
        for _, pos in ipairs(grid) do
          if pos.y == instruction.a then
            pos.x = (pos.x + instruction.b) % (self.test and 3 or 6)
          end
        end
      end,
      row = function()
        for _, pos in ipairs(grid) do
          if pos.x == instruction.a then
            pos.y = (pos.y + instruction.b) % (self.test and 7 or 50)
          end
        end
      end,
    }
  end
  return grid
end

function M:solve1()
  self.solution:add("1", #self:solver())
end

function M:solve2()
  local str = {}
  for i = 1, self.test and 3 or 6 do
    str[i] = {}
    for j = 1, self.test and 7 or 50 do
      str[i][j] = " "
    end
  end

  for _, pos in ipairs(self:solver()) do
    str[pos.x + 1][pos.y + 1] = "#"
  end

  for i, row in ipairs(str) do
    str[i] = table.concat(row, "")
  end

  self.solution:add("2", str)
end

M:run()

return M
