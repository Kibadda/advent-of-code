local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2023", "03")

function M:parse_input(file)
  self.input = {
    numbers = {},
    grid = {},
  }

  local i = 1
  for line in file:lines() do
    table.insert(self.input.grid, line)

    local j = 1
    while line:at(j) do
      if tonumber(line:at(j)) then
        local num = tonumber(line:at(j))
        local k = 1
        while tonumber(line:at(j + k)) do
          num = 10 * num + tonumber(line:at(j + k))
          k = k + 1
        end

        table.insert(self.input.numbers, {
          num = num,
          line = i,
          s = j,
          e = j + k - 1,
        })

        j = j + k
      end

      j = j + 1
    end

    i = i + 1
  end
end

function M:solve1()
  local parts = 0

  for _, number in ipairs(self.input.numbers) do
    local found = false
    for i = number.line - 1, number.line + 1 do
      for j = number.s - 1, number.e + 1 do
        if self.input.grid[i] and j >= 1 and j <= #self.input.grid[i] then
          if not tonumber(self.input.grid[i]:at(j)) and self.input.grid[i]:at(j) ~= "." then
            parts = parts + number.num
            found = true
          end
        end
      end

      if found then
        break
      end
    end
  end

  self.solution:add("1", parts)
end

function M:solve2()
  local gears = 0

  for i, line in ipairs(self.input.grid) do
    for j = 1, #line do
      if line:at(j) == "*" then
        local ad = table.filter(self.input.numbers, function(number)
          return not (i + 1 < number.line)
            and not (i - 1 > number.line)
            and not (j + 1 < number.s)
            and not (j - 1 > number.e)
        end)

        if #ad == 2 then
          gears = gears + ad[1].num * ad[2].num
        end
      end
    end
  end

  self.solution:add("2", gears)
end

M:run()

return M
