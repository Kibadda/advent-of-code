local Solution = require "advent-of-code.Solution"

---@class AOCDay
---@field year string
---@field day string
---@field input table
---@field solution Solution
---@field parse_input (fun(self: AOCDay, file: file*)) parses input
---@field solve1 (fun(self: AOCDay)) solves first problem
---@field solve2 (fun(self: AOCDay)) solves second problem
---@field solve (fun(self: AOCDay, use_test_input: boolean): Solution) solves all problems
---@field new (fun(self: AOCDay, year: string, day: string): AOCDay) create new AOCDay
---@field run (fun(self: AOCDay, use_test_input: boolean)) run
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
  solve = function(self, use_test_input)
    local file_name = use_test_input and "test.txt" or "input.txt"
    local path = ("./lua/advent-of-code/%s/%s/%s"):format(self.year, self.day, file_name)
    local file = io.open(path, "r")

    if file then
      self:parse_input(file)
      self:solve1()
      self:solve2()

      return self.solution
    end

    local error = Solution:new()
    error:add("one", "file error")
    error:add("two", "file error")

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
  run = function(self, use_test_input)
    self:solve(use_test_input):print()
  end,
}

return AOCDay
