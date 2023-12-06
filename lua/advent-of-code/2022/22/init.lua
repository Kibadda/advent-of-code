local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2022", "22")

function M:parse(file)
  self.input = {
    grid = {},
    path = {},
  }

  local parse_grid = true
  for line in file:lines() do
    if line == "" then
      parse_grid = false
    end

    if parse_grid then
      table.insert(self.input.grid, line)
    else
      local num = 0
      for c in line:gmatch "." do
        if c == "L" or c == "R" then
          table.insert(self.input.path, num)
          num = 0
          table.insert(self.input.path, c)
        else
          num = num * 10 + c
        end
      end
      if num > 0 then
        table.insert(self.input.path, num)
      end
    end
  end
end

function M:wrap(next, dir, version)
  if version == "map" then
    if dir.y == 0 then
      -- vertical wrap
      if dir.x > 0 then
        for i = 1, #self.input.grid do
          if self.input.grid[i]:at(next.y) ~= " " and self.input.grid[1]:at(next.y) ~= nil then
            next = V(i, next.y)
            break
          end
        end
      else
        for i = #self.input.grid, 1, -1 do
          if self.input.grid[i]:at(next.y) ~= " " and self.input.grid[i]:at(next.y) ~= nil then
            next = V(i, next.y)
            break
          end
        end
      end
    else
      -- horizontal wrap
      if dir.y > 0 then
        next = V(next.x, self.input.grid[next.x]:find "%S")
      else
        next = V(next.x, #self.input.grid[next.x] - self.input.grid[next.x]:reverse():find "%S" + 1)
      end
    end
  else
    --   AABB
    --   AABB
    --   CC
    --   CC
    -- DDEE
    -- DDEE
    -- FF
    -- FF

    -- A top TO F left
    if next.x == 0 and next.y >= 51 and next.y <= 100 then
      next = V(next.y + 100, 1)
      dir = V(0, 1)

    -- F left TO A top
    elseif next.x >= 151 and next.x <= 200 and next.y == 0 then
      next = V(1, next.x - 100)
      dir = V(1, 0)

    -- B top TO F bot
    elseif next.x == 0 and next.y >= 101 and next.y <= 150 then
      next = V(200, next.y - 100)
      dir = V(-1, 0)

    -- F bot TO B top
    elseif next.x == 201 and next.y >= 1 and next.y <= 50 then
      next = V(1, next.y + 100)
      dir = V(1, 0)

    -- B right TO E right
    elseif next.x >= 1 and next.x <= 50 and next.y == 151 then
      next = V(151 - next.x, 100)
      dir = V(0, -1)

    -- E right TO B right
    elseif next.x >= 101 and next.x <= 150 and next.y == 101 then
      next = V(151 - next.x, 150)
      dir = V(0, -1)

    -- B bot TO C right
    elseif next.x == 51 and next.y >= 101 and next.y <= 150 and dir == V(1, 0) then
      next = V(next.y - 50, 100)
      dir = V(0, -1)

    -- C right TO B bot
    elseif next.x >= 51 and next.x <= 100 and next.y == 101 and dir == V(0, 1) then
      next = V(50, next.x + 50)
      dir = V(-1, 0)

    -- E bot TO F right
    elseif next.x == 151 and next.y >= 51 and next.y <= 100 and dir == V(1, 0) then
      next = V(next.y + 100, 50)
      dir = V(0, -1)

    -- F right TO E bot
    elseif next.x >= 151 and next.x <= 200 and next.y == 51 and dir == V(0, 1) then
      next = V(150, next.x - 100)
      dir = V(-1, 0)

    -- D left to A left
    elseif next.x >= 101 and next.x <= 150 and next.y == 0 then
      next = V(151 - next.x, 51)
      dir = V(0, 1)

    -- A left TO D left
    elseif next.x >= 1 and next.x <= 50 and next.y == 50 then
      next = V(151 - next.x, 1)
      dir = V(0, 1)

    -- D top TO C left
    elseif next.x == 100 and next.y >= 1 and next.y <= 50 and dir == V(-1, 0) then
      next = V(next.y + 50, 51)
      dir = V(0, 1)

    -- C left TO D top
    elseif next.x >= 51 and next.x <= 100 and next.y == 50 and dir == V(0, -1) then
      next = V(101, next.x - 50)
      dir = V(1, 0)
    else
      error "this should not happen"
    end

    --     AA
    --     AA
    -- BBCCDD
    -- BBCCDD
    --     EEFF
    --     EEFF

    -- -- A top TO B top
    -- if next.x == 0 and next.y >= 9 and next.y <= 12 then
    --   next = V(5, 13 - next.y)
    --   dir = V(1, 0)

    -- -- B top TO A top
    -- elseif next.x == 8 and next.y >= 1 and next.y <= 4 then
    --   next = V(1, 13 - next.y)
    --   dir = V(1, 0)

    -- -- A right TO F right
    -- elseif next.x >= 1 and next.x <= 4 and next.y == 13 then
    --   next = V(13 - next.x, 16)
    --   dir = V(0, -1)

    -- -- F right TO A right
    -- elseif next.x >= 9 and next.x <= 12 and next.y == 17 then
    --   next = V(13 - next.x, 12)
    --   dir = V(0, -1)

    -- -- D right TO F top
    -- elseif next.x >= 5 and next.x <= 8 and next.y == 13 and dir == V(0, 1) then
    --   next = V(9, 21 - next.x)
    --   dir = V(1, 0)

    -- -- F top TO D right
    -- elseif next.x == 7 and next.y >= 13 and next.y <= 16 and dir == V(-1, 0) then
    --   next = V(21 - next.y, 12)
    --   dir = V(0, -1)

    -- -- F bot TO B left
    -- elseif next.x == 13 and next.y >= 13 and next.y <= 16 then
    --   next = V(21 - next.y, 1)
    --   dir = V(0, 1)

    -- -- B left TO F bot
    -- elseif next.x >= 5 and next.x <= 8 and next.y == 1 then
    --   next = V(12, 21 - next.y)
    --   dir = V(-1, 0)

    -- -- E bot TO B bot
    -- elseif next.x == 13 and next.y >= 9 and next.y <= 12 then
    --   next = V(8, 13 - next.y)
    --   dir = V(-1, 0)

    -- -- B bot TO E bot
    -- elseif next.x == 9 and next.y >= 1 and next.y <= 4 then
    --   next = V(12, 13 - next.y)
    --   dir = V(-1, 0)

    -- -- E left to C bot
    -- elseif next.x >= 9 and next.x <= 12 and next.y == 8 and dir == V(0, -1) then
    --   next = V(8, 17 - next.x)
    --   dir = V(-1, 0)

    -- -- C bot TO E left
    -- elseif next.x == 9 and next.y >= 5 and next.y <= 9 and dir == V(1, 0) then
    --   next = V(17 - next.y, 9)
    --   dir = V(0, 1)

    -- -- C top TO A left
    -- elseif next.x == 4 and next.y >= 5 and next.y <= 9 and dir == V(-1, 0) then
    --   next = V(next.y - 4, 9)
    --   dir = V(0, 1)

    -- -- A left TO C top
    -- elseif next.x >= 1 and next.x <= 4 and next.y == 8 and dir == V(0, -1) then
    --   next = V(5, next.x + 4)
    --   dir = V(1, 0)
    -- else
    --   error "this should not happen"
    -- end
  end

  return next, dir
end

function M:solver(version)
  local pos = V(1, self.input.grid[1]:find "[^%s#]")
  local dir = V(0, 1)

  for _, instruction in ipairs(self.input.path) do
    if type(instruction) == "string" then
      dir = dir * instruction
    else
      for _ = 1, instruction do
        local next = pos + dir
        local next_dir = dir
        if
          next.x > #self.input.grid
          or next.x < 1
          or self.input.grid[next.x]:at(next.y) == " "
          or self.input.grid[next.x]:at(next.y) == nil
          or next.y < 1
          or next.y > #self.input.grid[next.x]
        then
          next, next_dir = self:wrap(next, dir, version)
        end

        if self.input.grid[next.x]:at(next.y) ~= "#" then
          pos = next
          dir = next_dir
        end
      end
    end
  end

  return 1000 * pos.x + 4 * pos.y + match(dir.x) {
    [0] = dir.y < 0 and 2 or 0,
    _ = dir.x < 0 and 3 or 1,
  }
end

function M:solve1()
  self.solution:add("1", self:solver "map")
end

function M:solve2()
  self.solution:add("2", self:solver "cube")
end

M:run()

return M
