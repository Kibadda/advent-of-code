--- @class AOCDay202511: AOCDay
--- @field input table<string, string[]>
local M = require("advent-of-code.AOCDay"):new("2025", "11")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local split = line:split ":? "
    self.input[split[1]] = { unpack(split, 2) }
  end
end

function M:solver(s, e, hash)
  hash = hash or {}
  hash[s] = table.reduce(self.input[s] or {}, 0, function(sum, device)
    if device == e then
      return sum + 1
    elseif hash[device] then
      return sum + hash[device]
    else
      return sum + self:solver(device, e, hash)
    end
  end)
  return hash[s]
end

function M:solve1()
  return self:solver(self.test and "svr" or "you", "out")
end

function M:solve2()
  return self:solver("svr", "fft") * self:solver("fft", "dac") * self:solver("dac", "out")
    + self:solver("svr", "dac") * self:solver("dac", "fft") * self:solver("fft", "out")
end

M:run()
