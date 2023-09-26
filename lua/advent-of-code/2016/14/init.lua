local AOC = require "advent-of-code.AOC"
AOC.reload()

local md5 = require "advent-of-code.helpers.md5"

local M = AOC.create("2016", "14")

function M:parse_input(file)
  for line in file:lines() do
    self.input = line
  end
end

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
          keys[#keys + 1] = self.input .. index
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
  self.solution:add(
    "1",
    self:solver(function(index)
      return md5.sumhexa(self.input .. index)
    end)
  )
end

function M:solve2()
  self.solution:add(
    "2",
    self:solver(function(index)
      local hash = self.input .. index
      for _ = 1, 2017 do
        hash = md5.sumhexa(hash)
      end
      return hash
    end)
  )
end

M:run()

return M
