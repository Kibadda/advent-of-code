local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "18")

local min_x, min_y, min_z = math.huge, math.huge, math.huge
local max_x, max_y, max_z = -math.huge, -math.huge, -math.huge

function M:parse_input(file)
  for line in file:lines() do
    local split = line:split ","
    local x = tonumber(split[1])
    local y = tonumber(split[2])
    local z = tonumber(split[3])
    self.input[x] = self.input[x] or {}
    self.input[x][y] = self.input[x][y] or {}
    self.input[x][y][z] = true
    min_x = math.min(min_x, x)
    min_y = math.min(min_y, y)
    min_z = math.min(min_z, z)
    max_x = math.max(max_x, x)
    max_y = math.max(max_y, y)
    max_z = math.max(max_z, z)
  end
end

function M:calculate_surface()
  local sides = 0
  for x = min_x, max_x do
    for y = min_y, max_y do
      for z = min_z, max_z do
        if self.input[x] ~= nil and self.input[x][y] ~= nil and self.input[x][y][z] and not self.input[x][y][z - 1] then
          sides = sides + 1
        end
      end
      for z = max_z, min_z, -1 do
        if self.input[x] ~= nil and self.input[x][y] ~= nil and self.input[x][y][z] and not self.input[x][y][z + 1] then
          sides = sides + 1
        end
      end
    end
  end

  for y = min_y, max_y do
    for z = min_z, max_z do
      for x = min_x, max_x do
        if
          self.input[x] ~= nil
          and self.input[x][y] ~= nil
          and self.input[x][y][z]
          and not (self.input[x - 1] ~= nil and self.input[x - 1][y] ~= nil and self.input[x - 1][y][z])
        then
          sides = sides + 1
        end
      end
      for x = max_x, min_x, -1 do
        if
          self.input[x] ~= nil
          and self.input[x][y] ~= nil
          and self.input[x][y][z]
          and not (self.input[x + 1] ~= nil and self.input[x + 1][y] ~= nil and self.input[x + 1][y][z])
        then
          sides = sides + 1
        end
      end
    end
  end

  for z = min_z, max_z do
    for x = min_x, max_x do
      for y = min_y, max_y do
        if
          self.input[x] ~= nil
          and self.input[x][y] ~= nil
          and self.input[x][y][z]
          and not (self.input[x][y - 1] ~= nil and self.input[x][y - 1][z])
        then
          sides = sides + 1
        end
      end
      for y = max_y, min_y, -1 do
        if
          self.input[x] ~= nil
          and self.input[x][y] ~= nil
          and self.input[x][y][z]
          and not (self.input[x][y + 1] ~= nil and self.input[x][y + 1][z])
        then
          sides = sides + 1
        end
      end
    end
  end

  return sides
end

function M:solve1()
  self.solution:add("1", self:calculate_surface())
end

function M:solve2()
  for x = min_x - 1, max_x + 1 do
    for y = min_y - 1, max_y + 1 do
      for z = min_z - 1, max_z + 1 do
        self.input[x] = self.input[x] or {}
        self.input[x][y] = self.input[x][y] or {}
        if not self.input[x][y][z] then
          self.input[x][y][z] = false
        end
      end
    end
  end

  local start = { x = min_x - 1, y = min_y - 1, z = min_z - 1 }
  local queue = { start }
  local seen = { start }
  local test

  while #queue > 0 do
    local current = table.remove(queue, 1)
    test = {
      x = current.x - 1,
      y = current.y,
      z = current.z,
    }
    if
      current.x >= min_x
      and table.find(seen, test, { "x", "y", "z" }) == nil
      and not self.input[test.x][test.y][test.z]
    then
      table.insert(queue, test)
      table.insert(seen, test)
    end

    test = {
      x = current.x + 1,
      y = current.y,
      z = current.z,
    }
    if
      current.x <= max_x
      and table.find(seen, test, { "x", "y", "z" }) == nil
      and not self.input[test.x][test.y][test.z]
    then
      table.insert(queue, test)
      table.insert(seen, test)
    end

    test = {
      x = current.x,
      y = current.y - 1,
      z = current.z,
    }
    if
      current.y >= min_y
      and table.find(seen, test, { "x", "y", "z" }) == nil
      and not self.input[test.x][test.y][test.z]
    then
      table.insert(queue, test)
      table.insert(seen, test)
    end

    test = {
      x = current.x,
      y = current.y + 1,
      z = current.z,
    }
    if
      current.y <= max_y
      and table.find(seen, test, { "x", "y", "z" }) == nil
      and not self.input[test.x][test.y][test.z]
    then
      table.insert(queue, test)
      table.insert(seen, test)
    end

    test = {
      x = current.x,
      y = current.y,
      z = current.z - 1,
    }
    if
      current.z >= min_z
      and table.find(seen, test, { "x", "y", "z" }) == nil
      and not self.input[test.x][test.y][test.z]
    then
      table.insert(queue, test)
      table.insert(seen, test)
    end

    test = {
      x = current.x,
      y = current.y,
      z = current.z + 1,
    }
    if
      current.z <= max_z
      and table.find(seen, test, { "x", "y", "z" }) == nil
      and not self.input[test.x][test.y][test.z]
    then
      table.insert(queue, test)
      table.insert(seen, test)
    end
  end

  local sides = self:calculate_surface()
  for x = min_x, max_x do
    for y = min_y, max_y do
      for z = min_z, max_z do
        if not self.input[x][y][z] and table.find(seen, { x = x, y = y, z = z }, { "x", "y", "z" }) == nil then
          if self.input[x + 1][y][z] then
            sides = sides - 1
          end
          if self.input[x - 1][y][z] then
            sides = sides - 1
          end
          if self.input[x][y + 1][z] then
            sides = sides - 1
          end
          if self.input[x][y - 1][z] then
            sides = sides - 1
          end
          if self.input[x][y][z + 1] then
            sides = sides - 1
          end
          if self.input[x][y][z - 1] then
            sides = sides - 1
          end
        end
      end
    end
  end

  self.solution:add("2", sides)
end

M:run()

return M
