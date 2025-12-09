---@class AOC
---@field reload function
---@field create (fun(year: string, day: string): AOCDay)
local AOC = {
  reload = function()
    for _, p in ipairs {
      "advent-of-code.Timer",
      "advent-of-code.Solution",
      "advent-of-code.AOCDay",
      "advent-of-code.helpers.functions",
      "advent-of-code.helpers.debug",
      "advent-of-code.helpers.table",
      "advent-of-code.helpers.string",
      "advent-of-code.helpers.math",
      "advent-of-code.helpers.Vector",
      "advent-of-code.helpers.Vector3",
    } do
      package.loaded[p] = nil
    end
  end,
  create = function(year, day)
    require "advent-of-code.helpers.functions"
    require "advent-of-code.helpers.debug"
    require "advent-of-code.helpers.table"
    require "advent-of-code.helpers.string"
    require "advent-of-code.helpers.math"
    require "advent-of-code.helpers.Vector"
    require "advent-of-code.helpers.Vector3"
    return require("advent-of-code.AOCDay"):new(year, day)
  end,
}

return AOC
