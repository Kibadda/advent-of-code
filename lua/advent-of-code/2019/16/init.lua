--- @class AOCDay201916: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "16")

function M:solver(input, offset)
  local phase = input:only_ints "%d"
  local length = #phase

  local function get_value_at(i, j)
    local pat_length = i * 4
    local pat_index = j % pat_length
    pat_index = math.ceil((pat_index + 1) / i)
    pat_index = pat_index == 0 and pat_length or pat_index

    local pat
    if pat_index == 1 or pat_index == 3 then
      pat = 0
    elseif pat_index == 2 then
      pat = 1
    elseif pat_index == 4 then
      pat = -1
    end

    return pat * phase[j]
  end

  for _ = 1, 100 do
    local next_phase = {}

    for i = 1, length do
      next_phase[i] = 0
      for j = 1, length do
        next_phase[i] = next_phase[i] + get_value_at(i, j)
      end
      next_phase[i] = math.abs(next_phase[i]) % 10
    end

    phase = next_phase
  end

  return table.concat {
    phase[1 + offset],
    phase[2 + offset],
    phase[3 + offset],
    phase[4 + offset],
    phase[5 + offset],
    phase[6 + offset],
    phase[7 + offset],
    phase[8 + offset],
  }
end

function M:solve1()
  return self:solver(self.input[1], 0)
end

function M:solve2()
  local offset = assert(tonumber(self.input[1]:sub(1, 7)))
  local input = self.input[1]:rep(10000):only_ints "%d"
  local length = #input

  for _ = 1, 100 do
    local sum = 0
    local cache = {}

    for k = offset, length do
      sum = sum + input[k]
    end

    for k = offset, length do
      cache[k] = sum % 10
      sum = sum - input[k]
    end

    input = cache
  end

  return table.concat {
    input[1 + offset],
    input[2 + offset],
    input[3 + offset],
    input[4 + offset],
    input[5 + offset],
    input[6 + offset],
    input[7 + offset],
    input[8 + offset],
  }
end

M:run()
