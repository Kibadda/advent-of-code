local Timer = require "advent-of-code.Timer"

--- @class Solution
--- @field new (fun(self: Solution): Solution)
--- @field add (fun(self: Solution, part: string, solution: any))
--- @field print (fun(self: Solution))
--- @field ["1"] any solution of first problem
--- @field ["2"] any solution of second problem
--- @field timer Timer
local Solution = {
  new = function(self)
    return setmetatable({
      ["1"] = nil,
      ["2"] = nil,
      timer = Timer:new(),
    }, {
      __index = self,
    })
  end,
  add = function(self, part, solution)
    self[part] = solution
  end,
  print = function(self)
    print "==== solution ===="
    print("  1: " .. tostring(self["1"]):fill(11))
    print("  2: " .. tostring(self["2"]):fill(11))
    if self.timer then
      local timings = self.timer:format()
      print "===== timing ====="
      if timings.parse then
        print("  p: " .. timings.parse:fill(11))
      end
      if timings.one then
        print("  1: " .. timings.one:fill(11))
      end
      if timings.two then
        print("  2: " .. timings.two:fill(11))
      end
      if timings.all then
        print("  a: " .. timings.all:fill(11))
      end
    end
    print "=================="
  end,
}

return Solution
