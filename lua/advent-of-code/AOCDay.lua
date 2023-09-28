local Solution = require "advent-of-code.Solution"
local Timing = require "advent-of-code.Timing"

---@class AOCDay
---@field year string
---@field day string
---@field input any
---@field solution Solution
---@field test boolean
---@field parse_input (fun(self: AOCDay, file: file*)) parses input
---@field solve1 (fun(self: AOCDay, input: any)) solves first problem
---@field solve2 (fun(self: AOCDay, input: any)) solves second problem
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
  parse_input = function(self, file)
    for line in file:lines() do
      table.insert(self.input, line)
    end
  end,
  solve1 = function(_) end,
  solve2 = function(_) end,
  run = function(self)
    local start = Timing.time()

    local file_name = self.test and "test.txt" or "input.txt"
    local path = ("./advent-of-code/%s/%s/%s"):format(self.year, self.day, file_name)
    local file = io.open(path, "r")

    if file then
      self:parse_input(file)
      local parsing = Timing.time()

      self:solve1()
      local one = Timing.time()
      self:solve2()
      local two = Timing.time()

      self.solution.took = Timing:new(start, parsing, one, two)
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
