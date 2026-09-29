--- @class AOCDay201912: AOCDay
--- @field input { pos: Vector3, vel: Vector3 }[]
local M = require("advent-of-code.AOCDay"):new("2019", "12")

--- @param lines string[]
function M:parse(lines)
  self.input = {}

  for _, line in ipairs(lines) do
    local ints = line:only_ints "-?%d+"

    table.insert(self.input, {
      pos = V3(ints[1], ints[2], ints[3]),
      vel = V3(0, 0, 0),
    })
  end
end

--- @param input { pos: Vector3, vel: Vector3 }[]
function M:step(input)
  for i, moon1 in ipairs(input) do
    for j, moon2 in ipairs(input) do
      if i ~= j then
        moon1.vel.x = moon1.vel.x + (moon1.pos.x < moon2.pos.x and 1 or moon1.pos.x > moon2.pos.x and -1 or 0)
        moon1.vel.y = moon1.vel.y + (moon1.pos.y < moon2.pos.y and 1 or moon1.pos.y > moon2.pos.y and -1 or 0)
        moon1.vel.z = moon1.vel.z + (moon1.pos.z < moon2.pos.z and 1 or moon1.pos.z > moon2.pos.z and -1 or 0)
      end
    end
  end

  for _, moon in ipairs(input) do
    moon.pos = moon.pos + moon.vel
  end
end

function M:solve1()
  local input = table.deepcopy(self.input)

  for _ = 1, self.test and 100 or 1000 do
    self:step(input)
  end

  return table.reduce(input, 0, function(energy, moon)
    return energy + moon.pos:distance() * moon.vel:distance()
  end)
end

function M:solve2()
  local input = table.deepcopy(self.input)

  local phase = {}
  local steps = 0
  while true do
    self:step(input)
    steps = steps + 1

    for _, pos in ipairs { "x", "y", "z" } do
      if
        not phase[pos]
        and table.reduce(input, true, function(same, moon, i)
          return same and moon.pos[pos] == self.input[i].pos[pos] and moon.vel[pos] == 0
        end)
      then
        phase[pos] = steps
      end
    end

    if phase.x and phase.y and phase.z then
      break
    end
  end

  return table.reduce(phase, 1, math.lcm, pairs)
end

M:run()
