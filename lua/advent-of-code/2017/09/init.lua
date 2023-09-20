local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "09")

function M:parse_input(file)
  for line in file:lines() do
    self.input = line
  end
end

function M:solve1()
  local score = 0
  local depth = 0
  local garbage = false
  local bang = false
  for i = 1, #self.input do
    match(self.input:at(i)) {
      ["{"] = function()
        if not garbage and not bang then
          depth = depth + 1
        end
        bang = false
      end,
      ["}"] = function()
        if not garbage and not bang then
          score = score + depth
          depth = depth - 1
        end
        bang = false
      end,
      ["<"] = function()
        if not bang then
          garbage = true
        end
        bang = false
      end,
      [">"] = function()
        if not bang then
          garbage = false
        end
        bang = false
      end,
      ["!"] = function()
        bang = not bang
      end,
      _ = function()
        bang = false
      end,
    }
  end
  self.solution:add("1", score)
end

function M:solve2()
  local characters = 0
  local garbage = false
  local bang = false
  for i = 1, #self.input do
    match(self.input:at(i)) {
      ["<"] = function()
        if not bang then
          if garbage then
            characters = characters + 1
          end
          garbage = true
        end
        bang = false
      end,
      [">"] = function()
        if not bang then
          garbage = false
        end
        bang = false
      end,
      ["!"] = function()
        bang = not bang
      end,
      _ = function()
        if garbage and not bang then
          characters = characters + 1
        end
        bang = false
      end,
    }
  end
  self.solution:add("2", characters)
end

M:run(false)

return M
