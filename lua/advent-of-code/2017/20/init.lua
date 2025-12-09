--- @class AOCDay201720: AOCDay
--- @field input { p: Vector3, v: Vector3, a: Vector3, i: number }[]
local M = require("advent-of-code.AOC").create("2017", "20")

--- @param file file*
function M:parse(file)
  for line in file:lines() do
    local ints = line:only_ints "-?%d+"
    local p = V3(ints[1], ints[2], ints[3])
    local v = V3(ints[4], ints[5], ints[6])
    local a = V3(ints[7], ints[8], ints[9])
    table.insert(self.input, {
      p = p,
      v = v,
      a = a,
      i = #self.input,
    })
  end
end

function M:solve1()
  table.sort(self.input, function(a, b)
    if a.a == b.a then
      if a.v == b.v then
        return a.p:distance() < a.p:distance()
      else
        return a.v:distance() < b.v:distance()
      end
    else
      return a.a:distance() < b.a:distance()
    end
  end)

  return self.input[1].i
end

function M:solve2()
  local no_changes = 0

  while true do
    if no_changes == 10000 then
      break
    end

    local pos = {}
    for i, par in spairs(self.input) do
      par.v = par.v + par.a
      par.p = par.p + par.v

      local k = par.p:string()
      pos[k] = pos[k] or {}
      table.insert(pos[k], i)
    end

    local changes = false
    for _, indices in spairs(pos) do
      if #indices > 1 then
        changes = true
        for _, index in ipairs(indices) do
          self.input[index] = nil
        end
      end
    end

    if changes then
      no_changes = 0
    else
      no_changes = no_changes + 1
    end
  end

  return table.count(self.input)
end

--[==[
THIS ALMOST WORKED, BUT IT WAS JUST TO GOOD TO BE TRUE

function M:parse(file)
  for line in file:lines() do
    local ints = line:only_ints "-?%d+"
    local p = V3(ints[1], ints[2], ints[3])
    local v = V3(ints[4], ints[5], ints[6])
    local a = V3(ints[7], ints[8], ints[9])
    table.insert(self.input, {
      a = a * 0.5,
      b = a * 0.5 + v,
      c = p,
      f = function(t)
        return a * 0.5 * t * t + (a * 0.5 + v) * t + p
      end,
    })
  end
end

function M:solve1()
  local distance = math.huge
  local index

  for i, par in ipairs(self.input) do
    local d = par.f(100000):distance()
    if d < distance then
      distance = d
      index = i - 1
    end
  end

  return index
end

function M:solve2()
  local changes = true
  local iteration = 0
  while changes do
    iteration = iteration + 1
    print(iteration, #self.input)
    local times = {}

    for i = 1, #self.input - 1 do
      for j = i + 1, #self.input do
        local a = p1.a - p2.a
        local b = p1.b - p2.b
        local c = p1.c - p2.c

        for _, s in ipairs { 1, -1 } do
          local same = true
          local number
          for _, u in pairs { "x", "y", "z" } do
            local n
            local skip = false

            if a[u] ~= 0 then
              n = (-b[u] + s * math.sqrt(b[u] * b[u] - 4 * a[u] * c[u])) / (2 * a[u])
            elseif b[u] ~= 0 then
              n = -c[u] / b[u]
            elseif c[u] == 0 then
              skip = true
            else
              same = false
              break
            end

            if not skip then
              if math.floor(n) ~= n or n < 0 then
                same = false
                break
              elseif not number then
                number = n
              elseif number ~= n then
                same = false
                break
              end
            end
          end

          if same and number then
            times[number] = times[number] or {}
            times[number][i] = 1
            times[number][j] = 1
          end
        end
      end
    end

    local keys = table.keys(times)
    if #keys == 0 then
      changes = false
    else
      table.sort(keys)
      local indices = table.keys(times[keys[1]])
      table.sort(indices, function(a, b)
        return b < a
      end)
      for _, index in ipairs(indices) do
        table.remove(self.input, index)
      end
    end
  end

  return #self.input
end
--]==]

M:run()
