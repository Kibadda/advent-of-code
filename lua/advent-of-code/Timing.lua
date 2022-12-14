---@class Timing
---@field parsing string
---@field one string
---@field two string
---@field sum string
---@field new (fun(self: Timing, start: number, parsing: number, one: number, two: number): Timing)
local Timing = {
  parsing = "",
  one = "",
  two = "",
  sum = "",
  new = function(self, start, parsing, one, two)
    local format_string = "%.3f"
    return setmetatable({
      parsing = format_string:format(parsing - start),
      one = format_string:format(one - parsing),
      two = format_string:format(two - one),
      sum = format_string:format(two - start),
    }, {
      __index = self,
    })
  end,
}

return Timing
