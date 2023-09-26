local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "08")

function M:parse_input(file)
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

function M:solver(dimensions)
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
            pos.x = (pos.x + instruction.b) % dimensions[1]
          end
        end
      end,
      row = function()
        for _, pos in ipairs(grid) do
          if pos.x == instruction.a then
            pos.y = (pos.y + instruction.b) % dimensions[2]
          end
        end
      end,
    }
  end
  return grid
end

function M:solve1(dimensions)
  self.solution:add("1", #self:solver(dimensions))
end

function M:solve2(dimensions)
  local str = {}
  for i = 1, dimensions[1] do
    str[i] = {}
    for j = 1, dimensions[2] do
      str[i][j] = " "
    end
  end

  for _, pos in ipairs(self:solver(dimensions)) do
    str[pos.x + 1][pos.y + 1] = "#"
  end

  for i, row in ipairs(str) do
    str[i] = table.concat(row, "")
  end

  self.solution:add("2", str)
end

M:run { { 3, 7 }, { 6, 50 } }

return M
