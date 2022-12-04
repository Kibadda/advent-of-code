---@class Solution
---@field one string|integer solution of first problem
---@field two string|integer solution of second problem

---@class AOCDay
---@field year string
---@field day string
---@field lines table<integer, string>
---@field parse_input (fun(self: AOCDay): table) parses input
---@field solve1 (fun(self: AOCDay): string|integer) solves first problem
---@field solve2 (fun(self: AOCDay): string|integer) solves second problem
---@field solve (fun(self: AOCDay, use_test_data: boolean): Solution) solves all problems
---@field new (fun(self: AOCDay, year: string, day: string): AOCDay) create new AOCDay
local AOCDay = {
  year = "",
  day = "",
  lines = {},
  parse_input = function(self)
    return self.lines
  end,
  solve1 = function(_)
    return "problem 1 not solved yet"
  end,
  solve2 = function(_)
    return "problem 2 not solved yet"
  end,
  solve = function(self, use_test_data)
    local file_name = use_test_data and "test.txt" or "input.txt"
    local path = ("./lua/advent-of-code/%s/%s/%s"):format(self.year, self.day, file_name)
    local file = io.open(path, "r")

    if file then
      self.lines = {}
      for line in file:lines() do
        table.insert(self.lines, line)
      end
    end

    return {
      one = self:solve1(),
      two = self:solve2(),
    }
  end,
  new = function(self, year, day)
    return setmetatable({
      year = year,
      day = day,
    }, {
      __index = self,
    })
  end,
}

function string:split(sep)
  sep = sep or "%s"
  local t = {}
  for str in self:gmatch("([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

return AOCDay
