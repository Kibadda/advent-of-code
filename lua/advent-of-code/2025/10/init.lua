--- @class AOCDay202510: AOCDay
--- @field input { lights: string, buttons: number[][], joltage: number[] }[]
local M = require("advent-of-code.AOC").create("2025", "10")

-- THANK YOU TO: https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/

--- @param file file*
function M:parse(file)
  for line in file:lines() do
    local split = line:split " "

    local machine = {
      lights = table.reduce(split[1]:sub(2, #split[1] - 1):to_list(), 0, function(lights, light, i)
        return light == "#" and bit.bor(lights, 2 ^ (i - 1)) or lights
      end),
      buttons = {},
      joltage = split[#split]:only_ints(),
    }

    for i = 2, #split - 1 do
      table.insert(
        machine.buttons,
        table.reduce(split[i]:only_ints(), 0, function(button, index)
          return bit.bor(button, 2 ^ index)
        end)
      )
    end

    table.insert(self.input, machine)
  end
end

function M:solver(buttons, joltages)
  local combinations = {}

  for mask = 0, (2 ^ #buttons) - 1 do
    local combo = {}
    for i = 1, #buttons do
      combo[i] = bit.band(mask, bit.lshift(1, i - 1)) ~= 0
    end

    table.insert(combinations, combo)
  end

  return table.reduce(combinations, {}, function(patterns, combination)
    if
      table.reduce(combination, 0, function(goal, use_button, i)
        return use_button and bit.bxor(goal, buttons[i]) or goal
      end) == joltages
    then
      table.insert(patterns, combination)
    end
    return patterns
  end)
end

function M:solve1()
  return table.reduce(self.input, 0, function(sum, machine)
    return sum
      + table.reduce(self:solver(machine.buttons, machine.lights), math.huge, function(min, mask)
        return math.min(
          min,
          table.reduce(mask, 0, function(s, bit)
            return s + (bit and 1 or 0)
          end)
        )
      end)
  end)
end

function M:solve2()
  local function solving(buttons, joltages, cache)
    cache = cache or {}

    local key = table.concat(joltages, "=")
    if cache[key] then
      return cache[key]
    end

    if table.sum(joltages) == 0 then
      return 0
    end

    cache[key] = table.reduce(
      self:solver(
        buttons,
        table.reduce(joltages, 0, function(jol, j, i)
          return j % 2 == 1 and bit.bor(jol, 2 ^ (i - 1)) or jol
        end)
      ),
      math.huge,
      function(min, mask)
        local cost = 0
        local new_joltages = table.reduce(mask, table.deepcopy(joltages), function(new, use_button, i)
          if use_button then
            cost = cost + 1
            for j = 1, #joltages do
              if bit.band(buttons[i], bit.lshift(1, j - 1)) ~= 0 then
                new[j] = new[j] - 1
              end
            end
          end

          return new
        end)

        if
          table.reduce(new_joltages, false, function(is_negative, j)
            return is_negative or j < 0
          end)
        then
          return min
        end

        return math.min(min, cost + 2 * solving(
          buttons,
          table.map(new_joltages, function(j)
            return j / 2
          end)
        ))
      end
    )

    return cache[key]
  end

  return table.reduce(self.input, 0, function(sum, machine)
    return sum + solving(machine.buttons, machine.joltage)
  end)
end

M:run()
