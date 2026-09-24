--- @class AOCDay201822: AOCDay
--- @field input { depth: integer, target: Vector }
local M = require("advent-of-code.AOCDay"):new("2018", "22")

--- @param lines string[]
function M:parse(lines)
  local target = lines[2]:only_ints()
  self.input = {
    depth = lines[1]:only_ints()[1],
    target = V(target[2] + 1, target[1] + 1),
  }
end

local erosion_level = {}

function M:solve1()
  local function calculate(x, y)
    local geologic_index

    if erosion_level[x] and erosion_level[x][y] then
      return erosion_level[x][y]
    elseif x == 1 and y == 1 then
      geologic_index = 0
    elseif x == self.input.target.x and y == self.input.target.y then
      geologic_index = 0
    elseif y == 1 then
      geologic_index = (x - 1) * 48271
    elseif x == 1 then
      geologic_index = (y - 1) * 16807
    else
      geologic_index = calculate(x - 1, y) * calculate(x, y - 1)
    end

    local level = (geologic_index + self.input.depth) % 20183
    erosion_level[x] = erosion_level[x] or {}
    erosion_level[x][y] = level
    return level
  end

  for i = 1, self.input.target.x + 100 do
    erosion_level[i] = {}
    for j = 1, self.input.target.y + 100 do
      calculate(i, j)
    end
  end

  local risk_level = 0
  for i = 1, self.input.target.x do
    for j = 1, self.input.target.y do
      risk_level = risk_level + erosion_level[i][j] % 3
    end
  end

  return risk_level
end

function M:solve2()
  return treesearch({
    depth = true,
    exit = function(current)
      if current.pos == self.input.target and current.equip == "T" then
        return true
      end

      return false
    end,
    compare = function(solution, current)
      if current.minutes < solution.minutes then
        return current
      end

      return solution
    end,
    bound = { minutes = 1000 },
    start = { pos = V(1, 1), equip = "T", minutes = 0, before = {} },
    memoize = function(current)
      return ("%s|%s|%s"):format(current.pos.x, current.pos.y, current.equip), current.minutes
    end,
    step = function(current, solution)
      local steps = {}

      if current.minutes >= solution.minutes then
        return steps
      end

      if current.minutes + self.input.target:distance(current.pos) >= solution.minutes then
        return steps
      end

      for _, pos in ipairs(current.pos:adjacent(4)) do
        if erosion_level[pos.x] and erosion_level[pos.x][pos.y] then
          local t = erosion_level[pos.x][pos.y] % 3

          if
            (current.equip == "T" and (t == 0 or t == 2))
            or (current.equip == "C" and (t == 0 or t == 1))
            or (current.equip == "N" and (t == 1 or t == 2))
          then
            table.insert(steps, {
              pos = pos,
              equip = current.equip,
              minutes = current.minutes + 1,
              before = current,
            })
          end
        end
      end

      local type = erosion_level[current.pos.x][current.pos.y] % 3

      if type == 0 then
        table.insert(steps, {
          pos = V(current.pos.x, current.pos.y),
          equip = current.equip ~= "T" and "T" or "C",
          minutes = current.minutes + 7,
          before = current,
        })
      elseif type == 1 then
        table.insert(steps, {
          pos = V(current.pos.x, current.pos.y),
          equip = current.equip ~= "C" and "C" or "N",
          minutes = current.minutes + 7,
          before = current,
        })
      elseif type == 2 then
        table.insert(steps, {
          pos = V(current.pos.x, current.pos.y),
          equip = current.equip ~= "N" and "N" or "T",
          minutes = current.minutes + 7,
          before = current,
        })
      end

      return steps
    end,
  }).minutes
end

M:run()
