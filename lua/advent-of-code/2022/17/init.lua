local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "17")

local function cycle(t)
  local function iter(ta, i)
    i = i + 1
    local v = ta[(i - 1) % table.count(ta) + 1]
    if v then
      return i, v
    end
  end

  return iter, t, 0
end

function M:parse_input(file)
  self.input = {
    drift = file:read(),
    shapes = table.map(("####|.#.,###,.#.|..#,..#,###|#,#,#,#|##,##"):split "|", function(shape)
      local t = {}
      for i, line in ipairs(shape:split ",") do
        for j = 1, #line do
          if line:sub(j, j) == "#" then
            table.insert(t, V(i - 1, j - 1))
          end
        end
      end
      return t
    end),
  }
end

function M:solver(rock_count)
  local occupied = {}
  local r_mins = {}
  local drift_i = 0
  local function in_bounds(v)
    return v.y >= 0 and v.y < 7 and v.x < 0 and table.find(occupied, v) == nil
  end
  local function shape_in_bounds(shape)
    return table.reduce(shape, true, function(curr, v)
      return curr and in_bounds(v)
    end)
  end
  local seen = {}
  local bonus = 0
  local occupied_r_min = 0
  local shape_i_target = rock_count
  for shape_i, shape in cycle(self.input.shapes) do
    local r_max = table.reduce(
      table.map(shape, function(v)
        return v.x
      end),
      -math.huge,
      function(curr, x)
        return math.max(curr, x)
      end
    )
    shape = table.map(shape, function(v)
      return v + V(-r_max - 4 + occupied_r_min, 2)
    end)
    while true do
      local drift
      if self.input.drift:sub(drift_i + 1, drift_i + 1) == "<" then
        drift = V(0, -1)
      elseif self.input.drift:sub(drift_i + 1, drift_i + 1) == ">" then
        drift = V(0, 1)
      end
      if shape_in_bounds(table.map(shape, function(v)
        return v + drift
      end)) then
        shape = table.map(shape, function(v)
          return v + drift
        end)
      end
      drift_i = (drift_i + 1) % #self.input.drift
      if shape_in_bounds(table.map(shape, function(v)
        return v + V(1, 0)
      end)) then
        shape = table.map(shape, function(v)
          return v + V(1, 0)
        end)
      else
        for _, v in ipairs(shape) do
          table.insert(occupied, v)
          occupied_r_min = math.min(occupied_r_min, v.x)
        end
        table.insert(r_mins, occupied_r_min)
        if shape_i == shape_i_target then
          return bonus - occupied_r_min
        end
        local memkey = ((shape_i - 1) % #self.input.shapes + 1)
          .. ","
          .. drift_i
          .. table.reduce(
            table.reduce(r_mins, {}, function(curr, val, i)
              if r_mins[i - 1] ~= nil then
                if #r_mins - i <= 5 then
                  table.insert(curr, r_mins[i - 1] - val)
                  return curr
                end
              end
              return curr
            end),
            "",
            function(curr, val)
              return curr .. "," .. val
            end
          )
        if seen[memkey] == nil then
          seen[memkey] = { shape_i, r_mins[#r_mins] }
        else
          if shape_i_target == rock_count then
            local period = shape_i - seen[memkey][1]
            bonus = (-r_mins[#r_mins] - -seen[memkey][2]) * math.floor((rock_count - shape_i + 1) / period)
            shape_i_target = shape_i + (rock_count - shape_i) % period
          end
        end
        break
      end
    end
  end
end

function M:solve1()
  self.solution:add("1", self:solver(2022))
end

function M:solve2()
  self.solution:add("2", self:solver(1000000000000))
end

M:run()

return M
