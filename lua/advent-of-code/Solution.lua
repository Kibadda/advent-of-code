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
      ["1"] = "not solved yet",
      ["2"] = "not solved yet",
      took = {},
    }, {
      __index = self,
    })
  end,
  add = function(self, part, solution)
    self[part] = solution
  end,
  print = function(self)
    print(table.to_string(self))
  end,
}

return Solution
