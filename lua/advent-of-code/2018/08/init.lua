--- @class AOCDay201808: AOCDay
--- @field input AOCDay201808Data
local M = require("advent-of-code.AOCDay"):new("2018", "08")

--- @class AOCDay201808Data
--- @field length integer
--- @field metadata integer[]
--- @field children AOCDay201808Data[]

--- @param lines string[]
function M:parse(lines)
  local list = lines[1]:only_ints()

  --- @return AOCDay201808Data
  local function traverse(pos)
    local children = {}
    local metadata = {}
    local length = 2 + list[pos + 1]

    local cur_pos = pos + 2
    for _ = 1, list[pos] do
      local child = traverse(cur_pos)
      length = length + child.length
      cur_pos = cur_pos + child.length
      table.insert(children, child)
    end

    for i = cur_pos, cur_pos + list[pos + 1] - 1 do
      table.insert(metadata, list[i])
    end

    return {
      children = children,
      metadata = metadata,
      length = length,
    }
  end

  self.input = traverse(1)
end

function M:solve1()
  --- @param data AOCDay201808Data
  local function sum(data)
    return table.sum(data.metadata)
      + table.reduce(data.children, 0, function(s, child)
        return s + sum(child)
      end)
  end

  return sum(self.input)
end

function M:solve2()
  --- @param data AOCDay201808Data
  local function sum(data)
    if #data.children > 0 then
      return table.reduce(data.metadata, 0, function(s, metadata)
        if data.children[metadata] then
          return s + sum(data.children[metadata])
        end

        return s
      end)
    else
      return table.sum(data.metadata)
    end
  end

  return sum(self.input)
end

M:run()
