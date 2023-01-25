---@class Solution
---@field new (fun(self: Solution): Solution)
---@field add (fun(self: Solution, part: string, solution: any))
---@field print (fun(self: Solution))
---@field ["1"] any solution of first problem
---@field ["2"] any solution of second problem
---@field took Timing
local Solution = {
  new = function(self)
    return setmetatable({
      ["1"] = nil,
      ["2"] = nil,
      took = {},
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
    if self.took then
      print "===== timing ====="
      if self.took.parsing then
        print("  p: " .. self.took.parsing:fill(11))
      end
      if self.took.solution_one then
        print("  1: " .. self.took.solution_one:fill(11))
      end
      if self.took.solution_two then
        print("  2: " .. self.took.solution_two:fill(11))
      end
      if self.took.all then
        print("  a: " .. self.took.all:fill(11))
      end
    end
    print "=================="
  end,
}

return Solution
