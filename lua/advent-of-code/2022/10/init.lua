local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "10")

function M:solve1()
  local signal = 0

  local x = 1
  local cycle = 1
  for _, line in ipairs(self.input) do
    local split = line:split()
    if split[1] == "noop" then
      cycle = cycle + 1
      if (cycle + 20) % 40 == 0 then
        signal = signal + x * cycle
      end
    else
      for i = 1, 2 do
        cycle = cycle + 1
        if i == 2 then
          x = x + split[2]
        end
        if (cycle + 20) % 40 == 0 then
          signal = signal + x * cycle
        end
      end
    end
  end

  self.solution:add("one", signal)
end

function M:solve2()
  local image = { "" }

  local x = 1
  local cycle = 1

  local function check_pos()
    local pos = x
    if pos == 1 then
      pos = 2
    elseif pos == 40 then
      pos = 39
    end

    local crt_pos = (cycle - 1) % 40
    return crt_pos == pos or crt_pos == pos - 1 or crt_pos == pos + 1
  end

  local index = 1
  for _, line in ipairs(self.input) do
    local split = line:split()
    if split[1] == "noop" then
      if check_pos() then
        image[index] = image[index] .. "#"
      else
        image[index] = image[index] .. "."
      end
      cycle = cycle + 1
      if cycle % 40 == 1 then
        index = index + 1
        image[index] = ""
      end
    else
      for i = 1, 2 do
        if check_pos() then
          image[index] = image[index] .. "#"
        else
          image[index] = image[index] .. "."
        end
        cycle = cycle + 1
        if cycle % 40 == 1 then
          index = index + 1
          image[index] = ""
        end
        if i == 2 then
          x = x + split[2]
        end
      end
    end
  end

  self.solution:add("two", image)
end

M:run(false)

return M
