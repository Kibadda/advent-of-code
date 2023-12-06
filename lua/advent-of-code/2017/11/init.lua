local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2017", "11")

function M:parse(file)
  for line in file:lines() do
    self.input = line
  end
end

function M:solver(dirs)
  local copy = table.deepcopy(dirs)

  copy = {
    n = copy.n - math.min(copy.n, copy.s),
    s = copy.s - math.min(copy.n, copy.s),
    ne = copy.ne - math.min(copy.ne, copy.sw),
    sw = copy.sw - math.min(copy.ne, copy.sw),
    nw = copy.nw - math.min(copy.nw, copy.se),
    se = copy.se - math.min(copy.nw, copy.se),
  }
  copy = {
    ne = copy.ne + math.min(copy.n, copy.se),
    n = copy.n - math.min(copy.n, copy.se),
    se = copy.se - math.min(copy.n, copy.se),
    sw = copy.sw + math.min(copy.s, copy.nw),
    s = copy.s - math.min(copy.s, copy.nw),
    nw = copy.nw - math.min(copy.s, copy.nw),
  }
  copy = {
    se = copy.se + math.min(copy.ne, copy.s),
    ne = copy.ne - math.min(copy.ne, copy.s),
    s = copy.s - math.min(copy.ne, copy.s),
    nw = copy.nw + math.min(copy.sw, copy.n),
    sw = copy.sw - math.min(copy.sw, copy.n),
    n = copy.n - math.min(copy.sw, copy.n),
  }
  copy = {
    s = copy.s + math.min(copy.se, copy.sw),
    se = copy.se - math.min(copy.se, copy.sw),
    sw = copy.sw - math.min(copy.se, copy.sw),
    n = copy.n + math.min(copy.nw, copy.ne),
    nw = copy.nw - math.min(copy.nw, copy.ne),
    ne = copy.ne - math.min(copy.nw, copy.ne),
  }

  return table.reduce(copy, 0, function(carry, dir)
    return carry + dir
  end, pairs)
end

function M:solve1()
  local path = self.input:split ","

  local dirs = { nw = 0, n = 0, ne = 0, se = 0, s = 0, sw = 0 }

  for _, dir in ipairs(path) do
    match(dir) {
      n = function()
        dirs.n = dirs.n + 1
      end,
      ne = function()
        dirs.ne = dirs.ne + 1
      end,
      se = function()
        dirs.se = dirs.se + 1
      end,
      s = function()
        dirs.s = dirs.s + 1
      end,
      sw = function()
        dirs.sw = dirs.sw + 1
      end,
      nw = function()
        dirs.nw = dirs.nw + 1
      end,
    }
  end

  self.solution:add("1", self:solver(dirs))
end

function M:solve2()
  local path = self.input:split ","

  local dirs = { nw = 0, n = 0, ne = 0, se = 0, s = 0, sw = 0 }
  local max = -math.huge

  for _, dir in ipairs(path) do
    match(dir) {
      n = function()
        dirs.n = dirs.n + 1
      end,
      ne = function()
        dirs.ne = dirs.ne + 1
      end,
      se = function()
        dirs.se = dirs.se + 1
      end,
      s = function()
        dirs.s = dirs.s + 1
      end,
      sw = function()
        dirs.sw = dirs.sw + 1
      end,
      nw = function()
        dirs.nw = dirs.nw + 1
      end,
    }
    max = math.max(max, self:solver(dirs))
  end
  self.solution:add("2", max)
end

M:run()

return M
