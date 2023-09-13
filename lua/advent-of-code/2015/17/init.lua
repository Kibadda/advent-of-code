local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "17")

function M:parse_input(file)
  local i = 0
  for line in file:lines() do
    i = i + 1
    table.insert(self.input, ("%d|%s"):format(i, line))
  end
end

local function check(t1, t2)
  if #t1 ~= #t2 then
    return false
  end

  table.sort(t1)
  table.sort(t2)
  for i = 1, #t1 do
    if t1[i] ~= t2[i] then
      return false
    end
  end
  return true
end

local function bfs(state, total)
  local queue = { state }

  local valid = {}
  while #queue > 0 do
    local current = table.remove(queue, 1)

    if current.capacity == total then
      local seen = false
      for _, val in ipairs(valid) do
        if check(val, current.used) then
          seen = true
          break
        end
      end
      if not seen then
        table.insert(valid, current.used)
      end
    else
      for i, container in ipairs(current.avail) do
        local split = container:split "|"
        if tonumber(split[2]) + current.capacity <= total then
          local copy = table.deepcopy(current)
          table.insert(copy.used, table.remove(copy.avail, i))
          copy.capacity = copy.capacity + tonumber(split[2])
          local seen = false
          for _, s in ipairs(queue) do
            if check(s.used, copy.used) and check(s.avail, copy.avail) then
              seen = true
              break
            end
          end
          if not seen then
            table.insert(queue, copy)
          end
        end
      end
    end
  end

  return valid
end

function M:solve1(total)
  local valid = bfs({ avail = self.input, used = {}, capacity = 0 }, total)
  self.solution:add("1", #valid)
end

function M:solve2(total)
  local valid = bfs({ avail = self.input, used = {}, capacity = 0 }, total)
  local min_container = math.huge
  local count = 0
  for _, val in ipairs(valid) do
    if #val == min_container then
      count = count + 1
    elseif #val < min_container then
      min_container = #val
      count = 1
    end
  end
  self.solution:add("2", count)
end

M:run(false, { 25, 150 }, { 25, 150 })

return M
