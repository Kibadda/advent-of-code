--- @class AOCDay202315: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2023", "15")

--- @param lines string[]
function M:parse(lines)
  self.input = lines[1]:split ","
end

--- @param s string
function M:solver(s)
  return table.reduce(s:to_list(), 0, function(hash, c)
    return ((hash + c:byte()) * 17) % 256
  end)
end

function M:solve1()
  return table.reduce(self.input, 0, function(sum, word)
    return sum + self:solver(word)
  end)
end

function M:solve2()
  --- @type table<integer, { label: string, lens: integer }[]>
  local boxes = {}

  for _, word in ipairs(self.input) do
    local split = word:split "=-"
    local box = self:solver(split[1]) + 1

    if split[2] then
      if boxes[box] then
        local inserted = false
        for _, lens in ipairs(boxes[box]) do
          if lens.label == split[1] then
            lens.lens = split[2]
            inserted = true
            break
          end
        end

        if not inserted then
          table.insert(boxes[box], {
            label = split[1],
            lens = split[2],
          })
        end
      else
        boxes[box] = {
          {
            label = split[1],
            lens = split[2],
          },
        }
      end
    else
      if boxes[box] then
        local index
        for i, lens in ipairs(boxes[box]) do
          if lens.label == split[1] then
            index = i
            break
          end
        end

        if index then
          table.remove(boxes[box], index)
        end
      end
    end
  end

  return table.reduce(boxes, 0, function(power, lenses, i)
    return table.reduce(lenses, power, function(box_power, lens, j)
      return box_power + i * j * lens.lens
    end)
  end, pairs)
end

M:run()
