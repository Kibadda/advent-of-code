--- @class AOCDay201621: AOCDay
--- @field input { cmd: string, what: string, [1]: number, [2]?: number }[]
local M = require("advent-of-code.AOCDay"):new("2016", "21")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local split = line:split()
    table.insert(
      self.input,
      match(split[1]) {
        swap = function()
          return {
            cmd = "swap",
            what = split[2],
            tonumber(split[3]) and tonumber(split[3]) + 1 or split[3],
            tonumber(split[6]) and tonumber(split[6]) + 1 or split[6],
          }
        end,
        rotate = match(split[2]) {
          based = function()
            return {
              cmd = "rotate",
              what = "based",
              split[7],
            }
          end,
          _ = function()
            return {
              cmd = "rotate",
              what = split[2],
              tonumber(split[3]),
            }
          end,
        },
        reverse = function()
          return {
            cmd = "reverse",
            tonumber(split[3]) + 1,
            tonumber(split[5]) + 1,
          }
        end,
        move = function()
          return {
            cmd = "move",
            tonumber(split[3]) + 1,
            tonumber(split[6]) + 1,
          }
        end,
      }
    )
  end
end

function M:solve1()
  return table.reduce(self.input, self.test and "abcde" or "abcdefgh", function(word, instruction)
    return match(instruction.cmd) {
      swap = match(instruction.what) {
        position = function()
          local min = math.min(instruction[1], instruction[2])
          local max = math.max(instruction[1], instruction[2])
          return word:sub(1, min - 1) .. word:at(max) .. word:sub(min + 1, max - 1) .. word:at(min) .. word:sub(max + 1)
        end,
        letter = function()
          return word:gsub(instruction[1], "z"):gsub(instruction[2], instruction[1]):gsub("z", instruction[2])
        end,
      },
      rotate = match(instruction.what) {
        based = function()
          local pos = word:find(instruction[1])
          local count = (pos + ((pos - 1) >= 4 and 1 or 0)) % #word
          return word:sub(#word - count + 1) .. word:sub(1, #word - count)
        end,
        left = function()
          return word:sub(instruction[1] + 1) .. word:sub(1, instruction[1])
        end,
        right = function()
          return word:sub(#word - instruction[1] + 1) .. word:sub(1, #word - instruction[1])
        end,
      },
      reverse = function()
        return word:sub(1, instruction[1] - 1)
          .. word:sub(instruction[1], instruction[2]):reverse()
          .. word:sub(instruction[2] + 1)
      end,
      move = function()
        if instruction[1] < instruction[2] then
          return word:sub(1, instruction[1] - 1)
            .. word:sub(instruction[1] + 1, instruction[2])
            .. word:at(instruction[1])
            .. word:sub(instruction[2] + 1)
        else
          return word:sub(1, instruction[2] - 1)
            .. word:at(instruction[1])
            .. word:sub(instruction[2], instruction[1] - 1)
            .. word:sub(instruction[1] + 1)
        end
      end,
    }
  end)
end

function M:solve2()
  local function ripairs(t)
    local function iter(ta, i)
      i = i - 1
      if ta[i] then
        return i, ta[i]
      end
    end
    return iter, t, #t + 1
  end
  return table.reduce(self.input, self.test and "decab" or "fbgdceah", function(word, instruction)
    return match(instruction.cmd) {
      swap = match(instruction.what) {
        position = function()
          local min = math.min(instruction[1], instruction[2])
          local max = math.max(instruction[1], instruction[2])
          return word:sub(1, min - 1) .. word:at(max) .. word:sub(min + 1, max - 1) .. word:at(min) .. word:sub(max + 1)
        end,
        letter = function()
          return word:gsub(instruction[1], "z"):gsub(instruction[2], instruction[1]):gsub("z", instruction[2])
        end,
      },
      rotate = match(instruction.what) {
        based = function()
          local pos = word:find(instruction[1])
          local count = (pos + ((pos - 1) >= 4 and 1 or 0)) % #word
          return word:sub(#word - count + 1) .. word:sub(1, #word - count)
        end,
        right = function()
          return word:sub(instruction[1] + 1) .. word:sub(1, instruction[1])
        end,
        left = function()
          return word:sub(#word - instruction[1] + 1) .. word:sub(1, #word - instruction[1])
        end,
      },
      reverse = function()
        return word:sub(1, instruction[1] - 1)
          .. word:sub(instruction[1], instruction[2]):reverse()
          .. word:sub(instruction[2] + 1)
      end,
      move = function()
        if instruction[1] < instruction[2] then
          return word:sub(1, instruction[1] - 1)
            .. word:at(instruction[2])
            .. word:sub(instruction[1], instruction[2] - 1)
            .. word:sub(instruction[2] + 1)
        else
          return word:sub(1, instruction[2] - 1)
            .. word:sub(instruction[2] + 1, instruction[1])
            .. word:at(instruction[2])
            .. word:sub(instruction[1] + 1)
        end
      end,
    }
  end, ripairs)
end

M:run()
