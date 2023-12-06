local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "13")

function M:parse(file)
  self.input = {}
  local last = 0
  for line in file:lines() do
    local split = line:only_ints()
    self.input[split[1]] = {
      range = split[2],
      dir = -1,
      pos = 1,
    }
    last = math.max(last, split[1])
  end
  for i = 0, last do
    self.input[i] = self.input[i] or {
      range = 0,
      dir = -1,
      pos = 1,
    }
  end
  self.input.last = last
end

function M:solver(puzzle, input)
  local score = 0
  input = input or table.deepcopy(self.input)
  local mem

  if puzzle == 2 then
    for j = 0, input.last do
      if input[j].pos == 1 or input[j].pos == input[j].range then
        input[j].dir = input[j].dir * -1
      end
      input[j].pos = input[j].pos + input[j].dir
    end
    mem = table.deepcopy(input)
  end

  for i = 0, input.last do
    if input[i].pos == 1 then
      score = score + i * input[i].range
      if puzzle == 2 then
        return mem
      end
    end

    for j = 0, input.last do
      if input[j].range > 0 then
        if input[j].pos == 1 or input[j].pos == input[j].range then
          input[j].dir = input[j].dir * -1
        end
        input[j].pos = input[j].pos + input[j].dir
      end
    end
  end

  if puzzle == 1 then
    return score
  else
    return nil
  end
end

function M:solve1()
  self.solution:add("1", self:solver(1))
end

function M:solve2()
  local input = table.deepcopy(self.input)
  local i = 1
  while true do
    input = self:solver(2, input)
    if not input then
      break
    end
    i = i + 1
  end
  self.solution:add("2", i)
end

M:run()

return M
