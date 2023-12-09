---@param x number
---@param y number
function math.gcd(x, y)
  while y > 0 do
    x, y = y, x % y
  end
  return x
end

---@param x number
---@param y number
function math.lcm(x, y)
  return x * y / math.gcd(x, y)
end
