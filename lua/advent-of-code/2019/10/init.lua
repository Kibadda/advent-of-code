--- @class AOCDay201910: AOCDay
--- @field input ("#"|".")[][]
local M = require("advent-of-code.AOCDay"):new("2019", "10")

--- @param lines string[]
function M:parse(lines)
  self.input = {}

  for _, line in ipairs(lines) do
    table.insert(self.input, line:to_list())
  end
end

function M:solver(i, j, input)
  local map = table.deepcopy(input)

  for k = 1, #map do
    for l = 1, #map[k] do
      if (i ~= k or j ~= l) and map[k][l] == "#" then
        local diff_x = i - k
        local diff_y = j - l

        local gcd = math.gcd(math.abs(diff_x), math.abs(diff_y))

        diff_x = diff_x / gcd
        diff_y = diff_y / gcd

        for m = 1, gcd - 1 do
          if map[k + m * diff_x] and map[k + m * diff_x][l + m * diff_y] == "#" then
            map[k][l] = "."
            break
          end
        end
      end
    end
  end

  return map
end

function M:solve1()
  local max = -math.huge
  local point = V(1, 1)

  for i = 1, #self.input do
    for j = 1, #self.input[i] do
      if self.input[i][j] == "#" then
        local map = self:solver(i, j, self.input)

        local count = table.reduce(map, 0, function(carry, row)
          return carry
            + table.reduce(row, 0, function(carry2, a)
              return carry2 + (a == "#" and 1 or 0)
            end)
        end) - 1

        if count > max then
          max = count
          point = V(i, j)
        end
      end
    end
  end

  return ("%s at %s:%s"):format(max, point.x, point.y)
end

function M:solve2()
  local ints = self.solution["1"]:only_ints()
  local point = V(ints[2], ints[3])
  local slopes = {}

  for i = 1, #self.input do
    for j = 1, #self.input[i] do
      if i ~= point.x or j ~= point.y then
        local diff_x = i - point.x
        local diff_y = j - point.y

        local gcd = math.gcd(math.abs(diff_x), math.abs(diff_y))

        diff_x = diff_x / gcd
        diff_y = diff_y / gcd

        slopes[("%s/%s"):format(diff_x, diff_y)] = true
      end
    end
  end

  local vectors = table.reduce(table.keys(slopes), {}, function(carry, slope)
    table.insert(carry, V(unpack(slope:only_ints "-?%d+")))
    return carry
  end)

  --- @param vec Vector
  local function vec_to_angle(vec)
    local deg = (math.atan2(-vec.x, vec.y) * 180) / math.pi

    if deg <= 90 and deg >= 0 then
      deg = math.abs(deg - 90)
    elseif deg < 0 then
      deg = math.abs(deg) + 90
    else
      deg = 450 - deg
    end

    return deg
  end

  table.sort(vectors, function(a, b)
    return vec_to_angle(a) < vec_to_angle(b)
  end)

  local vaporized = 0
  while true do
    for _, vec in ipairs(vectors) do
      for m = 1, 100 do
        local i = point.x + m * vec.x
        local j = point.y + m * vec.y

        if self.input[i] and self.input[i][j] == "#" then
          self.input[i][j] = "."

          vaporized = vaporized + 1

          if vaporized == 200 then
            return (j - 1) * 100 + (i - 1)
          end

          break
        end
      end
    end
  end
end

M:run()
