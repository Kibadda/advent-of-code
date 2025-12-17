--- @class AOCDay201709: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2017", "09")

--- @param lines string[]
function M:parse(lines)
  self.input = lines[1]
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
  return score
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
  return characters
end

M:run()
