local Solution = require "advent-of-code.Solution"
local Timing = require "advent-of-code.Timing"

---@class AOCDay
---@field year string
---@field day string
---@field input table
---@field solution Solution
---@field parse_input (fun(self: AOCDay, file: file*)) parses input
---@field solve1 (fun(self: AOCDay, input: any)) solves first problem
---@field solve2 (fun(self: AOCDay, input: any)) solves second problem
---@field solve (fun(self: AOCDay, use_test_input: boolean, input1: any, input2: any): Solution) solves all problems
---@field new (fun(self: AOCDay, year: string, day: string): AOCDay) create new AOCDay
---@field run (fun(self: AOCDay, use_test_input: boolean, input1: any, input2: any)) run
---@field __super AOCDay
local AOCDay = {
  year = "",
  day = "",
  input = {},
  solution = {},
  parse_input = function(self, file)
    for line in file:lines() do
      table.insert(self.input, line)
    end
  end,
  solve1 = function(_) end,
  solve2 = function(_) end,
  solve = function(self, use_test_input, input1, input2)
    local start = Timing.time()

    local file_name = use_test_input and "test.txt" or "input.txt"
    local dir = debug.getinfo(2, "S").source:sub(2, 2) == "." and "" or "/lua"
    local path = (".%s/advent-of-code/%s/%s/%s"):format(dir, self.year, self.day, file_name)
    local file = io.open(path, "r")

    if file then
      self:parse_input(file)
      local parsing = Timing.time()

      self:solve1(input1)
      local one = Timing.time()
      self:solve2(input2)
      local two = Timing.time()

      self.solution.took = Timing:new(start, parsing, one, two)

      return self.solution
    end

    local error = Solution:new()
    error:add("1", "file error")
    error:add("2", "file error")

    return error
  end,
  new = function(self, year, day)
    return setmetatable({
      year = year,
      day = day,
      input = {},
      solution = Solution:new(),
      __super = self,
    }, {
      __index = self,
    })
  end,
  run = function(self, use_test_input, input1, input2)
    self:solve(use_test_input, input1, input2):print()
  end,
}

return AOCDay
