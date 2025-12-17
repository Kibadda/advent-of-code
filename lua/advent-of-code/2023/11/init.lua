--- @class AOCDay202311: AOCDay
--- @field input { galaxies: Vector[], empty: { rows: table<integer,boolean>, cols: table<integer,boolean> } }
local M = require("advent-of-code.AOCDay"):new("2023", "11")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    galaxies = {},
    empty = {
      rows = {},
      cols = {},
    },
  }

  local init = true
  for i, line in ipairs(lines) do
    if init then
      for k = 1, #line do
        self.input.empty.cols[k] = true
      end

      init = false
    end

    if not line:find "#" then
      self.input.empty.rows[i] = true
    end

    for j, c in ipairs(line:to_list()) do
      if c == "#" then
        table.insert(self.input.galaxies, V(i, j))
        self.input.empty.cols[j] = nil
      end
    end
  end
end

function M:solver(apart)
  --- @param a Vector
  --- @param b Vector
  local function get_empty(a, b)
    local empty = 0

    for i = math.min(a.x, b.x), math.max(a.x, b.x) do
      if self.input.empty.rows[i] then
        empty = empty + 1
      end
    end

    for i = math.min(a.y, b.y), math.max(a.y, b.y) do
      if self.input.empty.cols[i] then
        empty = empty + 1
      end
    end

    return empty
  end

  return table.reduce(self.input.galaxies, 0, function(sum, galaxy, index)
    for j = index + 1, #self.input.galaxies do
      sum = sum + galaxy:distance(self.input.galaxies[j]) + (apart - 1) * get_empty(galaxy, self.input.galaxies[j])
    end

    return sum
  end)
end

function M:solve1()
  return self:solver(2)
end

function M:solve2()
  return self:solver(1000000)
end

M:run()
