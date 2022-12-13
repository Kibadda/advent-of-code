local AOCDay = require "advent-of-code.AOCDay"

---@class AOC
---@field reload function
---@field create (fun(year: string, day: string): AOCDay)
local AOC = {
  reload = function()
    local solution = "advent-of-code.Solution"
    package.loaded[solution] = nil
    require(solution)

    local aoc = "advent-of-code.AOCDay"
    package.loaded[aoc] = nil
    require(aoc)

    local helpers = "advent-of-code.helpers"
    package.loaded[helpers] = nil
    require(helpers)
  end,
  create = function(year, day)
    return AOCDay:new(year, day)
  end,
}

return AOC
