---@class Solution
---@field one string|integer solution of first problem
---@field two string|integer solution of second problem

---@class AOCDay
---@field lines table<integer, string>
---@field parse_input (fun(self: AOCDay): table) parses input
---@field read_input (fun(self: AOCDay, use_test_data: boolean): table) reads input
---@field solve (fun(self: AOCDay, use_test_data: boolean): Solution) solves all problems
---@field solve1 (fun(self: AOCDay): string|integer) solves first problem
---@field solve2 (fun(self: AOCDay): string|integer) solves second problem

---@param year string
---@param day string
---@return AOCDay
local function create_object(year, day)
  local obj = {
    lines = {},
  }

  function obj:read_input(use_test_data)
    local file_name = use_test_data and "test.txt" or "input.txt"
    local path = ("./lua/advent-of-code/%s/%s/%s"):format(year, day, file_name)
    local file = io.open(path, "r")

    if file then
      obj.lines = {}
      for line in file:lines() do
        table.insert(obj.lines, line)
      end
    end
  end

  function obj:solve1()
    return "solve1 was not overwritten"
  end

  function obj:solve2()
    return "solve2 was not overwritten"
  end

  function obj:parse_input() end

  function obj:solve(use_test_data)
    self:read_input(use_test_data)

    return {
      one = self:solve1(),
      two = self:solve2(),
    }
  end

  return obj
end

return create_object
