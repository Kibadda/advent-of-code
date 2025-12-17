local Solution = require "advent-of-code.Solution"

--- @param file file*
--- @return string[]
local function parse_file(file)
  local lines = {}

  for line in file:lines() do
    table.insert(lines, line)
  end

  return lines
end

--- @class AOCDay
--- @field year string
--- @field day string
--- @field input any
--- @field solution Solution
--- @field test boolean
--- @field parse? (fun(self: AOCDay, lines: string[])) parses input
--- @field solve1 (fun(self: AOCDay): any) solves first problem
--- @field solve2 (fun(self: AOCDay): any) solves second problem
--- @field new (fun(self: AOCDay, year: string, day: string): AOCDay) create new AOCDay
--- @field run (fun(self: AOCDay)) run
local AOCDay = {
  year = "",
  day = "",
  input = {},
  solution = {},
  test = false,
  run = function(self)
    local file_name = self.test and "test.txt" or "input.txt"
    local path = ("./advent-of-code/%s/%s/%s"):format(self.year, self.day, file_name)
    local file = io.open(path, "r")

    if file then
      self.solution.timer:start()

      local lines = parse_file(file)

      if self.parse then
        self:parse(lines)
      else
        self.input = lines
      end
      self.solution.timer:parse()

      self.solution:add("1", self:solve1())
      self.solution.timer:one()

      self.solution:add("2", self:solve2())
      self.solution.timer:two()

      if os.getenv "TIMINGS" then
        print(JSON.stringify(self.solution.timer.timings))
      else
        self.solution:print()
      end
    else
      local error = Solution:new()
      error:add("1", "file error")
      error:add("2", "file error")
      error:print()
    end
  end,
  new = function(self, year, day)
    require "advent-of-code.helpers.functions"
    require "advent-of-code.helpers.debug"
    require "advent-of-code.helpers.table"
    require "advent-of-code.helpers.string"
    require "advent-of-code.helpers.math"
    require "advent-of-code.helpers.Vector"
    require "advent-of-code.helpers.Vector3"
    require "advent-of-code.helpers.md5"
    require "advent-of-code.helpers.json"

    return setmetatable({
      year = year,
      day = day,
      input = {},
      solution = Solution:new(),
      test = arg[1] == "1",
    }, {
      __index = self,
    })
  end,
}

return AOCDay
