--- @class Vector3
--- @field new (fun(self: Vector3, x: number, y: number, z: number): Vector3)
--- @field distance (fun(self: Vector3, v?: Vector3): number)
--- @field string fun(self: Vector3): string
--- @field x number
--- @field y number
--- @field z number
--- @operator add(Vector3): Vector3
--- @operator mul(number|Vector3): Vector3
local Vector3 = {}

local mt = {
  --- @param self Vector3
  --- @param v Vector3
  __add = function(self, v)
    return V3(self.x + v.x, self.y + v.y, self.z + v.z)
  end,
  --- @param self Vector3
  --- @param v Vector3
  __sub = function(self, v)
    return V3(self.x - v.x, self.y - v.y, self.z - v.z)
  end,
  --- @param self Vector3
  --- @param v Vector3
  __eq = function(self, v)
    return self.x == v.x and self.y == v.y and self.z == v.z
  end,
  --- @param self Vector3
  --- @param n number|Vector3
  --- @return Vector3
  __mul = function(self, n)
    if type(n) == "number" then
      return V3(self.x * n, self.y * n, self.z * n)
    else
      return V3(self.x * n.x, self.y * n.y, self.z * n.y)
    end
  end,
  __index = Vector3,
}

Vector3 = {
  x = 0,
  y = 0,
  z = 0,
  --- @param self Vector3
  --- @param x number
  --- @param y number
  --- @param z number
  new = function(self, x, y, z)
    mt.__index = self
    return setmetatable({
      x = x,
      y = y,
      z = z,
    }, mt)
  end,
  --- @param self Vector3
  --- @param v? Vector3
  distance = function(self, v)
    v = v or V3(0, 0, 0)
    return math.abs(self.x - v.x) + math.abs(self.y - v.y) + math.abs(self.z - v.z)
  end,
  --- @param self Vector3
  string = function(self)
    return ("%d|%d|%d"):format(self.x, self.y, self.z)
  end,
}

--- @param x number
--- @param y number
--- @param z number
function _G.V3(x, y, z)
  return Vector3:new(x, y, z)
end
