---@param value integer|string|boolean
function _G.match(value)
  local function re(v)
    if type(v) == "function" then
      return v(value)
    else
      return v
    end
  end

  return function(cases)
    for k, v in pairs(cases) do
      if type(k) == "table" then
        for _, key in ipairs(k) do
          if key == value then
            return re(v)
          end
        end
      else
        if k == value then
          return re(v)
        end
      end
    end
    if cases._ then
      return re(cases._)
    end
  end
end

---@param a number
---@param b number
function _G.gcd(a, b)
  while b > 0 do
    a, b = b, a % b
  end
  return a
end

---@param a number
---@param b number
function _G.lcm(a, b)
  return a * b / gcd(a, b)
end

---@generic T: table, V
---@param t T
---@return (fun(table: V[], i?: integer): integer, V), T, integer
function _G.cycle(t)
  local length = table.count(t)

  local function iter(ta, i)
    i = i + 1
    if i > length then
      i = 1
    end
    return i, ta[i]
  end

  return iter, t, 0
end
