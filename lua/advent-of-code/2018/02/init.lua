--- @class AOCDay201802: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2018", "02")

function M:solve1()
  local twos = 0
  local threes = 0

  for _, word in ipairs(self.input) do
    local two_changed = false
    local three_changed = false
    for _, i in pairs(table.frequencies(word:to_list())) do
      if not two_changed and i == 2 then
        two_changed = true
        twos = twos + 1
      end
      if not three_changed and i == 3 then
        three_changed = true
        threes = threes + 1
      end
    end
  end

  return twos * threes
end

function M:solve2()
  for i = 1, #self.input do
    for j = i + 1, #self.input do
      local diffs = 0
      local index
      for k = 1, #self.input[i] do
        if self.input[i]:at(k) ~= self.input[j]:at(k) then
          diffs = diffs + 1
          index = k
        end
      end
      if diffs == 1 then
        return self.input[i]:sub(1, index - 1) .. self.input[i]:sub(index + 1)
      end
    end
  end
end

M:run()
