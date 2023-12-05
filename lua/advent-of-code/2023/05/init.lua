local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2023", "05")

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

function M:parse_input(file)
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
    seeds = {},
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
      self.input.seeds = line:only_ints()
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

  local ids = table.deepcopy(self.input.seeds)

  while key do
    ids = table.map(ids, function(id)
      return self.input[key][id]
    end)
    key = next_map(key)
  end

  self.solution:add(
    "1",
    table.reduce(ids, math.huge, function(min, id)
      return math.min(min, id)
    end)
  )
end

function M:solve2()
  local ids = {}
  for i = 1, #self.input.seeds, 2 do
    ids[#ids + 1] = {
      { s = self.input.seeds[i], e = self.input.seeds[i] + self.input.seeds[i + 1], used = false },
    }
  end

  local key = "seed_to_soil"

  while key do
    ids = table.map(ids, function(ranges)
      local length = #ranges
      for j = 1, length do
        for i = 1, #self.input[key].source do
          local map = self.input[key]

          if map.source[i] <= ranges[j].e and map.source[i] + map.range[i] - 1 >= ranges[j].s then
            if map.source[i] > ranges[j].s then
              table.insert(ranges, { s = ranges[j].s, e = map.source[i] - 1, used = true })
              ranges[j].s = map.source[i]
            end

            if map.source[i] + map.range[i] - 1 < ranges[j].e then
              table.insert(ranges, { s = map.source[i] + map.range[i], e = ranges[j].e, used = true })
              ranges[j].e = map.source[i] + map.range[i] - 1
            end

            ranges[j] = { s = map[ranges[j].s], e = map[ranges[j].e], used = true }
          end

          if ranges[j].used then
            break
          end
        end
      end

      return table.map(ranges, function(range)
        return { s = range.s, e = range.e, used = false }
      end)
    end)

    key = next_map(key)
  end

  self.solution:add(
    "2",
    table.reduce(ids, math.huge, function(min, ranges)
      return math.min(
        min,
        table.reduce(ranges, math.huge, function(range_min, range)
          return math.min(range_min, range.s)
        end)
      )
    end)
  )
end

M:run()

return M
