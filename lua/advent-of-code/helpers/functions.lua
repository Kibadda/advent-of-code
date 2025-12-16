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

---@generic T: table, V
---@param t T
---@return (fun(table: V[], i?: integer): integer, V), T, integer
function _G.spairs(t)
  local keys = {}
  for k in pairs(t) do
    table.insert(keys, k)
  end
  table.sort(keys)

  local i = 0
  local function iter()
    i = i + 1
    if keys[i] then
      return keys[i], t[keys[i]]
    end
  end

  return iter, t, 0
end

--- @class TreesearchOpts
--- @field start any
--- @field bound any
--- @field depth boolean
--- @field exit fun(current): boolean
--- @field step fun(current, solution): table
--- @field compare? fun(solution, current): any
--- @field memoize? fun(current): string, any

--- @param opts TreesearchOpts
function _G.treesearch(opts)
  local queue = { opts.start }

  local solution = opts.bound

  local hash = {}

  while #queue > 0 do
    local current = table.remove(queue, not opts.depth and 1 or nil)

    local skip = false
    if opts.memoize then
      local key, value = opts.memoize(current)

      if value then
        if hash[key] and hash[key] <= value then
          skip = true
        else
          hash[key] = value
        end
      else
        if hash[key] then
          skip = true
        else
          hash[key] = true
        end
      end
    end

    if not skip then
      if opts.exit(current) then
        if not opts.depth then
          return current
        else
          solution = opts.compare(solution, current)
        end
      else
        for _, s in ipairs(opts.step(current, solution)) do
          table.insert(queue, s)
        end
      end
    end
  end

  return solution
end
