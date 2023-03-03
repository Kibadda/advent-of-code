local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "04")

function M:parse_input(file)
  for line in file:lines() do
    local split = line:split "-"
    local last = table.remove(split, #split)
    local id = tonumber(last:match "%d*")
    local checksum = last:match("%[[^%]]*%]"):sub(2, -2)
    table.insert(self.input, {
      split = split,
      id = id,
      checksum = checksum,
    })
  end
end

function M:solver()
  local filtered = {}

  for _, room in ipairs(self.input) do
    local counts = {}
    for c in table.concat(room.split, ""):gmatch "." do
      counts[c] = counts[c] and counts[c] + 1 or 1
    end

    local sorted = {}
    for k, v in pairs(counts) do
      sorted[#sorted + 1] = v .. k
    end

    table.sort(sorted, function(a, b)
      if a:at(1) ~= b:at(1) then
        return a > b
      else
        return a < b
      end
    end)

    local split = room.checksum:to_list()
    local check = true
    for i, c in ipairs(split) do
      if c ~= sorted[i]:at(2) then
        check = false
        break
      end
    end

    if check then
      table.insert(filtered, room)
    end
  end

  return filtered
end

function M:solve1()
  local sum = 0

  for _, room in ipairs(self:solver()) do
    sum = sum + room.id
  end

  self.solution:add("1", sum)
end

function M:solve2()
  local id
  for _, room in ipairs(self:solver()) do
    ---@type string[]
    local split = room.split
    local name = {}
    for _, word in ipairs(split) do
      local new_word = ""
      for c in word:gmatch "." do
        local new_c = ((((c:byte() - 97) + room.id) % 26 + 97) .. ""):char()
        new_word = new_word .. new_c
      end
      table.insert(name, new_word)
    end
    if table.concat(name, " ") == "northpole object storage" then
      id = room.id
      break
    end
  end

  self.solution:add("2", id)
end

M:run(false)

return M
