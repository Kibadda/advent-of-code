--- @class AOCDay201807: AOCDay
--- @field input { c: string, requirements: table<string, boolean> }[]
local M = require("advent-of-code.AOCDay"):new("2018", "07")

--- @param lines string[]
function M:parse(lines)
  local matrix = {}
  for _, line in ipairs(lines) do
    local b = line:at(6)
    local a = line:at(37)

    if b and a then
      matrix[b] = matrix[b] or {}
      matrix[a] = matrix[a] or {}
      matrix[a][b] = true
    end
  end

  self.input = table.reduce(matrix, {}, function(m, requirements, c)
    table.insert(m, { c = c, requirements = requirements })
    return m
  end, pairs)
end

function M:solve1()
  local input = table.deepcopy(self.input)
  local s = ""

  for _ = 1, #input do
    table.sort(input, function(a, b)
      local ac = table.count(a.requirements)
      local bc = table.count(b.requirements)

      if ac == bc then
        return a.c < b.c
      else
        return ac < bc
      end
    end)

    local c = table.remove(input, 1)
    for _, a in ipairs(input) do
      a.requirements[c.c] = nil
    end
    s = s .. c.c
  end

  return s
end

function M:solve2()
  local time = self.test and 0 or 60

  --- @type { c: string, time: integer }[]
  local workers = {}
  for i = 1, self.test and 2 or 5 do
    workers[i] = { c = ".", time = math.huge }
  end

  local seconds = 0
  while #self.input > 0 do
    local available_workers = {}

    for i, worker in ipairs(workers) do
      if worker.c ~= "." then
        if worker.time > 1 then
          workers[i].time = worker.time - 1
        else
          workers[i] = {
            c = ".",
            time = math.huge,
          }
          for _, a in ipairs(self.input) do
            a.requirements[worker.c] = nil
          end
          table.insert(available_workers, i)
        end
      else
        table.insert(available_workers, i)
      end
    end

    table.sort(self.input, function(a, b)
      local ac = table.count(a.requirements)
      local bc = table.count(b.requirements)

      if ac == bc then
        return a.c < b.c
      else
        return ac < bc
      end
    end)

    local amount = 1
    while true do
      if #available_workers == 0 or not self.input[amount] or table.count(self.input[amount].requirements) > 0 then
        break
      end

      local w_index = table.remove(available_workers, 1)
      local c = self.input[amount]
      workers[w_index] = {
        c = c.c,
        time = time + c.c:byte() - ("A"):byte() + 1,
      }
      amount = amount + 1
    end

    for _ = 1, amount - 1 do
      table.remove(self.input, 1)
    end

    seconds = seconds + 1
  end

  return seconds
    + table.reduce(workers, 0, function(sum, worker)
      return sum + (worker.c ~= "." and worker.time - 1 or 0)
    end)
end

M:run()
