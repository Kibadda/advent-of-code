--- @class AOCDay202508: AOCDay
--- @field input { x: number, y: number, z: number }[]
local M = require("advent-of-code.AOCDay"):new("2025", "08")

--- @param lines string[]
function M:parse(lines)
  for _, line in ipairs(lines) do
    local split = line:only_ints()
    table.insert(self.input, {
      x = split[1],
      y = split[2],
      z = split[3],
    })
  end
end

local function key(box)
  return box.x .. "," .. box.y .. "," .. box.z
end

function M:calculate_circuits(grid)
  local circuits = {}
  local checked = {}

  for _, box in ipairs(self.input) do
    local key_box = key(box)

    if not checked[key_box] then
      local circuit = {}
      local to_check = { key_box }

      while #to_check > 0 do
        local current = table.remove(to_check, 1)
        checked[current] = true

        if not circuit[current] then
          circuit[current] = true
          for c in pairs(grid[current] or {}) do
            table.insert(to_check, c)
          end
        end
      end

      table.insert(circuits, circuit)
    end
  end

  return circuits
end

function M:calculate_closest(grid)
  local distance = math.huge
  local key_a, key_b
  local closest_a, closest_b

  for i = 1, #self.input - 1 do
    for j = i + 1, #self.input do
      local key_tmp_a = key(self.input[i])
      local key_tmp_b = key(self.input[j])

      if not grid[key_tmp_a] or not grid[key_tmp_a][key_tmp_b] then
        local d = math.pow(self.input[i].x - self.input[j].x, 2)
          + math.pow(self.input[i].y - self.input[j].y, 2)
          + math.pow(self.input[i].z - self.input[j].z, 2)

        if d < distance then
          distance = d
          key_a = key_tmp_a
          key_b = key_tmp_b
          closest_a = self.input[i]
          closest_b = self.input[j]
        end
      end
    end
  end

  grid[key_a] = grid[key_a] or {}
  grid[key_a][key_b] = true
  grid[key_b] = grid[key_b] or {}
  grid[key_b][key_a] = true

  return closest_a, closest_b
end

function M:solve1()
  local grid = {}

  for _ = 1, self.test and 10 or 1000 do
    self:calculate_closest(grid)
  end

  local circuits = self:calculate_circuits(grid)

  circuits = table.map(circuits, function(circuit)
    return table.count(circuit)
  end)

  table.sort(circuits, function(a, b)
    return b < a
  end)

  return circuits[1] * circuits[2] * circuits[3]
end

function M:solve2()
  local grid = {}
  local closest_a, closest_b

  while true do
    closest_a, closest_b = self:calculate_closest(grid)

    if #self:calculate_circuits(grid) == 1 then
      break
    end
  end

  return closest_a.x * closest_b.x
end

M:run()
