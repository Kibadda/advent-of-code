---@class Vector
---@field new (fun(x: number, y: number): Vector)
---@field x number
---@field y number
local Vector

local mt = {
  ---@param v1 Vector
  ---@param v2 Vector
  __add = function(v1, v2)
    return Vector.new(v1.x + v2.x, v1.y + v2.y)
  end,
  ---@param v1 Vector
  ---@param v2 Vector
  __eq = function(v1, v2)
    return v1.x == v2.x and v1.y == v2.y
  end,
  __index = Vector,
}

Vector = {
  new = function(x, y)
    return setmetatable({
      x = x,
      y = y,
    }, mt)
  end,
}

function _G.V(x, y)
  return Vector.new(x, y)
end

return Vector
