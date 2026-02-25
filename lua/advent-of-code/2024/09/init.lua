--- @class AOCDay202409: AOCDay
--- @field input integer[]
local M = require("advent-of-code.AOCDay"):new("2024", "09")

--- @param lines string[]
function M:parse(lines)
  for _, c in ipairs(lines[1]:to_list()) do
    table.insert(self.input, tonumber(c))
  end
end

--- @param formatter fun(blocks: integer[]): integer[]
function M:solver(formatter)
  --- @type integer[]
  local blocks = {}
  local is_free = false
  local id = 1

  for _, i in ipairs(self.input) do
    for _ = 1, i do
      if is_free then
        table.insert(blocks, 0)
      else
        table.insert(blocks, id)
      end
    end

    if not is_free then
      id = id + 1
    end

    is_free = not is_free
  end

  return table.reduce(formatter(blocks), 0, function(sum, n, i)
    if n == 0 then
      return sum
    else
      return sum + (i - 1) * (n - 1)
    end
  end)
end

function M:solve1()
  return self:solver(function(blocks)
    local i = 1
    while i < #blocks do
      if blocks[i] == 0 then
        for n = #blocks, i, -1 do
          if blocks[n] ~= 0 then
            blocks[i] = blocks[n]
            blocks[n] = 0
            break
          end
        end
      end
      i = i + 1
    end

    return blocks
  end)
end

function M:solve2()
  return self:solver(function(blocks)
    local length = 0
    local number = 0

    for ii, n in ipairs(table.reverse(blocks)) do
      local i = #blocks - ii
      if n ~= number then
        if length > 0 and number > 0 then
          for jj, k in ipairs(table.windows(blocks, length)) do
            local j = jj - 1
            if j > i then
              break
            end
            if table.reduce(k, true, function(all, u)
              return all and u == 0
            end) then
              for o = 1, length do
                blocks[j + o] = blocks[i + 1 + o]
                blocks[i + 1 + o] = 0
              end
              break
            end
          end
        end
        number = n
        length = 1
      else
        length = length + 1
      end
    end

    return blocks
  end)
end

M:run()
