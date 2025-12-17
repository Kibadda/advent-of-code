--- @class AOCDay201614: AOCDay
--- @field input string
local M = require("advent-of-code.AOCDay"):new("2016", "14")

function M:solver(generate_hash_func)
  local keys = {}
  local hashes = {}
  local index = 0
  while true do
    if not hashes[index] then
      hashes[index] = generate_hash_func(index)
    end
    local char = hashes[index]:match "(.)%1%1"
    if char then
      for i = 1, 1000 do
        if not hashes[index + i] then
          hashes[index + i] = generate_hash_func(index + i)
        end
        if hashes[index + i]:find(char .. char .. char .. char .. char) then
          keys[#keys + 1] = self.input[1] .. index
          break
        end
      end
    end
    if #keys == 64 then
      break
    end
    index = index + 1
  end
  return index
end

function M:solve1()
  return self:solver(function(index)
    return MD5.sumhexa(self.input[1] .. index)
  end)
end

function M:solve2()
  return self:solver(function(index)
    local hash = self.input[1] .. index
    for _ = 1, 2017 do
      hash = MD5.sumhexa(hash)
    end
    return hash
  end)
end

M:run()
