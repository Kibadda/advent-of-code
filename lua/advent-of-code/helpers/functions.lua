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
