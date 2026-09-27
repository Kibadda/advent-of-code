--- @class AOCDay201908: AOCDay
--- @field input { layers: integer[][][], width: integer, height: integer }
local M = require("advent-of-code.AOCDay"):new("2019", "08")

--- @param lines string[]
function M:parse(lines)
  self.input = {
    layers = {},
    width = self.test and 3 or 25,
    height = self.test and 2 or 6,
  }

  local w, h = 1, 1
  local layer = {}
  for _, pixel in ipairs(lines[1]:only_ints "%d") do
    layer[h] = layer[h] or {}
    layer[h][w] = pixel

    if w == self.input.width then
      if h == self.input.height then
        table.insert(self.input.layers, layer)
        layer = {}
        w, h = 1, 1
      else
        w = 1
        h = h + 1
      end
    else
      w = w + 1
    end
  end
end

function M:solve1()
  local index = 1
  local min = math.huge

  for i, layer in ipairs(self.input.layers) do
    local count_0 = table.reduce(layer, 0, function(carry, row)
      return carry + #table.filter(row, function(pixel)
        return pixel == 0
      end)
    end)

    if count_0 < min then
      index = i
      min = count_0
    end
  end

  local ones = 0
  local twos = 0

  for _, row in ipairs(self.input.layers[index]) do
    for _, pixel in ipairs(row) do
      if pixel == 1 then
        ones = ones + 1
      end
      if pixel == 2 then
        twos = twos + 1
      end
    end
  end

  return ones * twos
end

function M:solve2()
  local image = {}

  for i = 1, self.input.height do
    image[i] = {}
    for j = 1, self.input.width do
      image[i][j] = 2
    end
  end

  for _, layer in ipairs(self.input.layers) do
    for i, row in ipairs(layer) do
      for j, pixel in ipairs(row) do
        if image[i][j] == 2 then
          image[i][j] = pixel
        end
      end
    end
  end

  for _, row in ipairs(image) do
    print(table.concat(row))
  end

  return "LRFKU"
end

M:run()
