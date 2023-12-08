local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay202305: AOCDay
---@field input { [1]: integer[], [string]: { dest: integer[], source: integer[], range: integer[], [integer]: integer } }
local M = AOC.create("2023", "05")

---@param key string
---@return string
local function next_map(key)
  return match(key) {
    seeds = "seed_to_soil",
    seed_to_soil = "soil_to_fertilizer",
    soil_to_fertilizer = "fertilizer_to_water",
    fertilizer_to_water = "water_to_light",
    water_to_light = "light_to_temperature",
    light_to_temperature = "temperature_to_humidity",
    temperature_to_humidity = "humidity_to_location",
  }
end

function M:parse(file)
  local mt = {
    __index = function(t, key)
      for i = 1, #t.source do
        if key >= t.source[i] and key <= t.source[i] + t.range[i] then
          return t.dest[i] + key - t.source[i]
        end
      end

      return key
    end,
  }

  self.input = {
    {},
    seed_to_soil = setmetatable({ dest = {}, source = {}, range = {} }, mt),
    soil_to_fertilizer = setmetatable({ dest = {}, source = {}, range = {} }, mt),
    fertilizer_to_water = setmetatable({ dest = {}, source = {}, range = {} }, mt),
    water_to_light = setmetatable({ dest = {}, source = {}, range = {} }, mt),
    light_to_temperature = setmetatable({ dest = {}, source = {}, range = {} }, mt),
    temperature_to_humidity = setmetatable({ dest = {}, source = {}, range = {} }, mt),
    humidity_to_location = setmetatable({ dest = {}, source = {}, range = {} }, mt),
  }

  local key = "seeds"
  for line in file:lines() do
    if line:match "seeds:" then
      self.input[1] = line:only_ints()
    elseif line == "" then
      key = next_map(key)
    else
      local dest_start, source_start, range = unpack(line:only_ints())

      table.insert(self.input[key].dest, dest_start)
      table.insert(self.input[key].source, source_start)
      table.insert(self.input[key].range, range)
    end
  end
end

function M:solve1()
  local key = "seed_to_soil"

  local ids = table.deepcopy(self.input[1])

  while key do
    ids = table.map(ids, function(id)
      return self.input[key][id]
    end)
    key = next_map(key)
  end

  return table.reduce(ids, math.huge, function(min, id)
    return math.min(min, id)
  end)
end

function M:solve2()
  ---@type { [1]: integer, [2]: integer }[]
  local ranges = {}

  for i = 1, #self.input[1], 2 do
    table.insert(ranges, {
      self.input[1][i],
      self.input[1][i] + self.input[1][i + 1] - 1,
    })
  end

  local key = "seed_to_soil"

  while key do
    local new_ranges = {}

    local i = 1
    while ranges[i] do
      local range = ranges[i]
      local map = self.input[key]
      local insert = true

      for j = 1, #map.source do
        local s = map.source[j]
        local e = map.source[j] + map.range[j] - 1

        if s <= range[1] and e >= range[2] then
          table.insert(new_ranges, {
            map[range[1]],
            map[range[2]],
          })

          insert = false
          break
        elseif s > range[1] and s <= range[2] and e >= range[2] then
          table.insert(new_ranges, {
            map.dest[j],
            map[range[2]],
          })

          range = {
            range[1],
            s - 1,
          }
        elseif e >= range[1] and e < range[2] and s <= range[1] then
          table.insert(new_ranges, {
            map[range[1]],
            map.dest[j] + map.range[j] - 1,
          })

          range = {
            e + 1,
            range[2],
          }
        elseif s > range[1] and s < range[2] and e > range[1] and e < range[1] then
          table.insert(new_ranges, {
            map.dest[j],
            map.dest[j] + map.range[j] - 1,
          })

          range = {
            range[1],
            s - 1,
          }

          table.insert(ranges, {
            e + 1,
            range[2],
          })
        end
      end

      if insert then
        table.insert(new_ranges, range)
      end

      i = i + 1
    end

    ranges = new_ranges
    key = next_map(key)
  end

  return table.reduce(ranges, math.huge, function(min, range)
    return math.min(min, range[1])
  end)
end

M:run()

return M
