--- @class AOCDay201804: AOCDay
--- @field input { id: integer, amount: integer, minute: integer[] }[]
local M = require("advent-of-code.AOCDay"):new("2018", "04")

--- @param lines string[]
function M:parse(lines)
  table.sort(lines)

  --- @type table<integer, { s: integer, e: integer }[]>
  local guards = {}

  local id, falls, wakes
  for _, line in ipairs(lines) do
    local ints = line:only_ints()

    if line:find "falls asleep" then
      falls = ints[5]
    elseif line:find "wakes up" then
      if falls then
        wakes = ints[5]
      end
    else
      id = ints[6]
      falls = nil
      wakes = nil
      guards[id] = guards[id] or {}
    end

    if falls and wakes then
      table.insert(guards[id], { s = falls, e = wakes })
      falls = nil
      wakes = nil
    end
  end

  self.input = table.values(table.map(guards, function(value, key)
    local minutes = {}

    return {
      id = key,
      amount = table.reduce(value, 0, function(sum, sleep)
        for i = sleep.s, sleep.e - 1 do
          minutes[i] = (minutes[i] or 0) + 1
        end

        return sum + sleep.e - sleep.s
      end),
      minute = table.reduce(minutes, { 0, 0 }, function(max, amount, minute)
        return amount > max[2] and { minute, amount } or max
      end, pairs),
    }
  end, pairs))
end

function M:solve1()
  local index = table.reduce(self.input, nil, function(idx, guard, ii)
    if not idx or self.input[idx].amount < guard.amount then
      return ii
    end

    return idx
  end)

  return self.input[index].id * self.input[index].minute[1]
end

function M:solve2()
  local index = table.reduce(self.input, nil, function(idx, guard, ii)
    if not idx or self.input[idx].minute[2] < guard.minute[2] then
      return ii
    end

    return idx
  end)

  return self.input[index].id * self.input[index].minute[1]
end

M:run()
