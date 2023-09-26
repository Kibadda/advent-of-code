local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "25")

local function from_snafu(str)
  local i = 0
  local num = 0
  for c in str:gmatch "." do
    i = i + 1
    num = num
      + math.pow(5, #str - i)
        * match(c) {
          ["2"] = 2,
          ["1"] = 1,
          ["0"] = 0,
          ["-"] = -1,
          ["="] = -2,
        }
  end
  return num
end

local function to_snafu(num)
  if num > 0 then
    if num % 5 < 3 then
      return to_snafu(math.floor(num / 5)) .. num % 5
    else
      return to_snafu(math.floor(num / 5) + 1) .. match(num % 5) {
        [3] = "=",
        [4] = "-",
      }
    end
  else
    return ""
  end
end

function M:parse_input(file)
  for line in file:lines() do
    self.input[line] = from_snafu(line)
  end
end

function M:solve1()
  local sum = table.reduce(self.input, 0, function(carry, v)
    return carry + v
  end, pairs)
  print(sum)
  local snafu = to_snafu(sum)
  print(from_snafu(snafu))
  self.solution:add("1", to_snafu(sum))
end

function M:solve2()
  self.solution:add("2", nil)
end

M:run()

return M
