local Solution = require "advent-of-code.Solution"

---@class AOCDay
---@field year string
---@field day string
---@field input any
---@field solution Solution
---@field test boolean
---@field parse (fun(self: AOCDay, file: file*)) parses input
---@field solve1 (fun(self: AOCDay): any) solves first problem
---@field solve2 (fun(self: AOCDay): any) solves second problem
---@field solver (fun(self: AOCDay, ...): any) placeholder function
---@field new (fun(self: AOCDay, year: string, day: string): AOCDay) create new AOCDay
---@field run (fun(self: AOCDay)) run
---@field __super AOCDay
local AOCDay = {
  year = "",
  day = "",
  input = {},
  solution = {},
  test = false,
  parse = function(self, file)
    for line in file:lines() do
      table.insert(self.input, line)
    end
  end,
  solve1 = function(_) end,
  solve2 = function(_) end,
  run = function(self)
    local file_name = self.test and "test.txt" or "input.txt"
    local path = ("./advent-of-code/%s/%s/%s"):format(self.year, self.day, file_name)
    local file = io.open(path, "r")

    if file then
      self.solution.timer:start()

      self:parse(file)
      self.solution.timer:parse()

      local one = self:solve1()
      if one then
        self.solution:add("1", one)
      end
      self.solution.timer:one()

      local two = self:solve2()
      if two then
        self.solution:add("2", two)
      end
      self.solution.timer:two()

      self.solution:print()
    else
      local error = Solution:new()
      error:add("1", "file error")
      error:add("2", "file error")
      error:print()
    end
  end,
  solver = function(_, ...) end,
  new = function(self, year, day)
    return setmetatable({
      year = year,
      day = day,
      input = {},
      solution = Solution:new(),
      test = arg[1] == "1",
      __super = self,
    }, {
      __index = self,
    })
  end,
}

return AOCDay
