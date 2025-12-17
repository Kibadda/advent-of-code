--- @class AOCDay201620: AOCDay
--- @field input { s: number, e: number }[]
local M = require("advent-of-code.AOCDay"):new("2016", "20")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local split = line:split "-"
    table.insert(self.input, {
      s = tonumber(split[1]),
      e = tonumber(split[2]),
    })
  end
end

function M:solve1()
  local lowest = 0

  while lowest < (self.test and 9 or 4294967295) do
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

  return lowest
end

function M:solve2()
  local ips = {}

  local lowest = 0

  while lowest <= (self.test and 9 or 4294967295) do
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
  return #ips
end

M:run()
