local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "07")

function M:solve1()
  local valid_ips = 0
  for _, ip in ipairs(self.input) do
    local abba_outside = false
    local abba_inside = false
    local inside_brackets = false
    for i = 1, #ip - 3 do
      ---@type string
      local str = ip:sub(i, i + 3)
      if str:find "%[" == 1 then
        inside_brackets = true
      elseif str:find "%]" == 1 then
        inside_brackets = false
      else
        if str:at(1) ~= str:at(2) and str:sub(1, 2) == str:sub(3, 4):reverse() then
          if inside_brackets then
            abba_inside = true
          else
            abba_outside = true
          end
        end
      end
    end
    if not abba_inside and abba_outside then
      valid_ips = valid_ips + 1
    end
  end
  self.solution:add("1", valid_ips)
end

function M:solve2()
  local valid_ips = 0
  for _, ip in ipairs(self.input) do
    local inside_brackets = false
    local aba = {}
    local bab = {}
    for i = 1, #ip - 2 do
      ---@type string
      local str = ip:sub(i, i + 2)
      if str:find "%[" then
        inside_brackets = true
      elseif str:find "%]" then
        inside_brackets = false
      else
        if str:at(1) ~= str:at(2) and str:at(1) == str:at(3) then
          if inside_brackets then
            bab[str:at(2) .. str:at(1) .. str:at(2)] = true
          else
            aba[str] = true
          end
        end
      end
    end
    for str in pairs(bab) do
      if aba[str] then
        valid_ips = valid_ips + 1
        break
      end
    end
  end
  self.solution:add("2", valid_ips)
end

M:run(false)

return M
