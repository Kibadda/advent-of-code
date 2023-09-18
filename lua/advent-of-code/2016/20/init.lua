local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "20")

function M:parse_input(file)
  local i = 0
  for line in file:lines() do
    i = i + 1
    local split = line:split "-"
    table.insert(self.input, {
      s = tonumber(split[1]),
      e = tonumber(split[2]),
    })
  end
end

function M:solve1(fin)
  local lowest = 0

  while lowest < fin do
    local found = false
    for _, range in ipairs(self.input) do
      if lowest >= range.s and lowest <= range.e then
        found = true
        lowest = range.e + 1
        break
      end
    end

    if not found then
      break
    end
  end

  self.solution:add("1", lowest)
end

function M:solve2(fin)
  local ips = {}

  local lowest = 0

  while lowest <= fin do
    local found = false
    for _, range in ipairs(self.input) do
      if lowest >= range.s and lowest <= range.e then
        found = true
        lowest = range.e + 1
        break
      end
    end

    if not found then
      table.insert(ips, lowest)
      lowest = lowest + 1
    end
  end
  self.solution:add("2", #ips)
end

M:run(false, { 9, 4294967295 }, { 9, 4294967295 })

return M
