--- @class Vector
--- @field new (fun(self: Vector, x: number, y: number): Vector)
--- @field distance (fun(self: Vector, v?: Vector): number)
--- @field adjacent fun(self: Vector, type?: 4|5|8|9): Vector[]
--- @field string fun(self: Vector): string
--- @field x number
--- @field y number
--- @operator add(Vector): Vector
--- @operator mul(string|number): Vector
local Vector = {}

local mt = {
  --- @param self Vector
  --- @param v Vector
  __add = function(self, v)
    return V(self.x + v.x, self.y + v.y)
  end,
  --- @param self Vector
  --- @param v Vector
  __eq = function(self, v)
    return self.x == v.x and self.y == v.y
  end,
  --- @param self Vector
  --- @param n string|number
  --- @return Vector
  __mul = function(self, n)
    if type(n) == "number" then
      return V(self.x * n, self.y * n)
    elseif type(n) == "string" then
      if n == "L" then
        return V(-self.y, self.x)
      elseif n == "R" then
        return V(self.y, -self.x)
      end
    end

    return self
  end,
  __index = Vector,
}

Vector = {
  x = 0,
  y = 0,
  --- @param self Vector
  --- @param x number
  --- @param y number
  new = function(self, x, y)
    mt.__index = self
    return setmetatable({
      x = x,
      y = y,
    }, mt)
  end,
  --- @param self Vector
  --- @param v? Vector
  distance = function(self, v)
    v = v or V(0, 0)
    return math.abs(self.x - v.x) + math.abs(self.y - v.y)
  end,
  --- @param self Vector
  --- @param type? 4|5|8|9
  adjacent = function(self, type)
    type = type or 4

    local r = {}

    if type >= 4 then
      r[#r + 1] = self + V(1, 0)
      r[#r + 1] = self + V(0, 1)
      r[#r + 1] = self + V(-1, 0)
      r[#r + 1] = self + V(0, -1)
    end

    if type >= 8 then
      r[#r + 1] = self + V(1, 1)
      r[#r + 1] = self + V(1, -1)
      r[#r + 1] = self + V(-1, 1)
      r[#r + 1] = self + V(-1, -1)
    end

    if type == 5 or type == 9 then
      r[#r + 1] = self
    end

    return r
  end,
  --- @param self Vector
  string = function(self)
    return ("%d|%d"):format(self.x, self.y)
  end,
}

--- @param x number
--- @param y number
function _G.V(x, y)
  return Vector:new(x, y)
end
