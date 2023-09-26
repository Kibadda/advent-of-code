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
  ---@param v Vector
  ---@param n string|number
  ---@return Vector
  __mul = function(v, n)
    if type(n) == "number" then
      return V(v.x * n, v.y * n)
    elseif type(n) == "string" then
      if n == "L" then
        return V(v.x == 0 and (v.y * -1) or v.y, v.y == 0 and v.x or (v.x * -1))
      elseif n == "R" then
        return V(v.x == 0 and v.y or (v.y * -1), v.y == 0 and (v.x * -1) or v.x)
      end
    end

    return v
  end,
  __index = Vector,
}

Vector = {
  x = 0,
  y = 0,
  ---@param x number
  ---@param y number
  new = function(x, y)
    return setmetatable({
      x = x,
      y = y,
    }, mt)
  end,
  ---@param v1 Vector
  ---@param v2 Vector
  distance = function(v1, v2)
    return math.abs(v1.x - v2.x) + math.abs(v1.y - v2.y)
  end,
}

---@param x number
---@param y number
function _G.V(x, y)
  return Vector.new(x, y)
end

---@param v1 Vector
---@param v2? Vector
function _G.Vdistance(v1, v2)
  v2 = v2 or V(0, 0)
  return Vector.distance(v1, v2)
end

return Vector
