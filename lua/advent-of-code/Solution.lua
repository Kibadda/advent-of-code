---@class Solution
---@field new (fun(self: Solution): Solution)
---@field add (fun(self: Solution, part: string, solution: any))
---@field print (fun(self: Solution))
---@field one any solution of first problem
---@field two any solution of second problem
---@field took Timing
local Solution = {
  new = function(self)
    return setmetatable({
      one = "not solved yet",
      two = "not solved yet",
      took = {
        parsing = 0,
        one = 0,
        two = 0,
        sum = 0,
      },
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
