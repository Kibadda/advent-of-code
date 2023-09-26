local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "09")

local function check_pos(head_pos, tail_pos)
  local diff_x = head_pos.x - tail_pos.x
  local diff_y = head_pos.y - tail_pos.y

  if math.abs(diff_x) > 1 or math.abs(diff_y) > 1 then
    if diff_x == 0 then
      tail_pos.y = tail_pos.y + (diff_y < 0 and -1 or 1)
    elseif diff_y == 0 then
      tail_pos.x = tail_pos.x + (diff_x < 0 and -1 or 1)
    else
      tail_pos.y = tail_pos.y + (diff_y < 0 and -1 or 1)
      tail_pos.x = tail_pos.x + (diff_x < 0 and -1 or 1)
    end
  end
end

function M:solve1()
  local all_tail_pos = {}
  local head_pos = { x = 0, y = 0 }
  local tail_pos = { x = 0, y = 0 }

  for _, line in ipairs(self.input) do
    local split = line:split()
    local direction = split[1]
    local amount = split[2]

    for _ = 1, amount do
      if direction == "U" then
        head_pos = { x = head_pos.x, y = head_pos.y + 1 }
      elseif direction == "R" then
        head_pos = { x = head_pos.x + 1, y = head_pos.y }
      elseif direction == "D" then
        head_pos = { x = head_pos.x, y = head_pos.y - 1 }
      elseif direction == "L" then
        head_pos = { x = head_pos.x - 1, y = head_pos.y }
      end
      check_pos(head_pos, tail_pos)
      if table.find(all_tail_pos, tail_pos) == nil then
        table.insert(all_tail_pos, {
          x = tail_pos.x,
          y = tail_pos.y,
        })
      end
    end
  end

  self.solution:add("1", #all_tail_pos)
end

function M:solve2()
  local all_tail_pos = {}
  local knots = {
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
  }

  for _, line in ipairs(self.input) do
    local split = line:split()
    local direction = split[1]
    local amount = split[2]

    for _ = 1, amount do
      if direction == "U" then
        knots[1] = { x = knots[1].x, y = knots[1].y + 1 }
      elseif direction == "R" then
        knots[1] = { x = knots[1].x + 1, y = knots[1].y }
      elseif direction == "D" then
        knots[1] = { x = knots[1].x, y = knots[1].y - 1 }
      elseif direction == "L" then
        knots[1] = { x = knots[1].x - 1, y = knots[1].y }
      end
      for i = 1, #knots - 1 do
        check_pos(knots[i], knots[i + 1])
      end
      if table.find(all_tail_pos, knots[10]) == nil then
        table.insert(all_tail_pos, {
          x = knots[10].x,
          y = knots[10].y,
        })
      end
    end
  end

  self.solution:add("2", #all_tail_pos)
end

M:run()

return M
