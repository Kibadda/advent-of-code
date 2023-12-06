local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay201714: AOCDay
---@field input { used: boolean, group: integer }[][]
local M = AOC.create("2017", "14")

---@param file file*
function M:parse(file)
  ---@param input string
  ---@return string
  local function knot_hash(input)
    local chain = {}
    for i = 1, 256 do
      chain[i] = i - 1
    end

    local lengths = {}
    for i, c in ipairs(input:to_list()) do
      lengths[i] = string.byte(c)
    end
    for _, c in ipairs { 17, 31, 73, 47, 23 } do
      lengths[#lengths + 1] = c
    end

    local index = 1
    local skip = 0
    for _ = 1, 64 do
      for _, length in ipairs(lengths) do
        local rev = {}
        for i = 0, length - 1 do
          if index + i > #chain then
            table.insert(rev, 1, chain[index + i - #chain])
          else
            table.insert(rev, 1, chain[index + i])
          end
        end
        for i = 0, length - 1 do
          if index + i > #chain then
            chain[index + i - #chain] = rev[i + 1]
          else
            chain[index + i] = rev[i + 1]
          end
        end
        index = index + length + skip
        while index > #chain do
          index = index - #chain
        end
        skip = skip + 1
      end
    end

    local dense = table.map(table.to_chunks(chain, 16), function(chunk)
      return bit.tohex(
        table.reduce(chunk, 0, function(carry, i)
          return bit.bxor(carry, i)
        end),
        2
      )
    end)

    return table.concat(dense)
  end

  self.input = {}

  local key = file:read()

  for i = 1, 128 do
    local hash = knot_hash(key .. "-" .. i - 1)
    for j, c in ipairs(hash:to_list()) do
      local num = tonumber(c, 16)
      for k = 0, 3 do
        self.input[i] = self.input[i] or {}
        self.input[i][(j - 1) * 4 + k + 1] = {
          used = bit.band(num, math.pow(2, 3 - k)) > 0,
          group = 0,
        }
      end
    end
  end
end

function M:solve1()
  return table.reduce(self.input, 0, function(total, row)
    return total + table.reduce(row, 0, function(used, cell)
      return used + (cell.used and 1 or 0)
    end)
  end)
end

function M:solve2()
  local grid = self.input
  local groups = {}

  local function key(i, j)
    return ("%d|%d"):format(i, j)
  end

  local function find(i, j)
    for k, group in ipairs(groups) do
      if group[key(i, j)] then
        return k
      end
    end
  end

  for i = 1, #grid do
    for j = 1, #grid[i] do
      if grid[i][j].used then
        local left, top

        if grid[i][j - 1] and grid[i][j - 1].used then
          left = find(i, j - 1)
        end

        if grid[i - 1] and grid[i - 1][j].used then
          top = find(i - 1, j)
        end

        if left == top then
          top = nil
        end

        if left and top then
          for pos in pairs(groups[math.max(left, top)]) do
            groups[math.min(left, top)][pos] = true
          end
          table.remove(groups, math.max(left, top))
          groups[math.min(left, top)][key(i, j)] = true
        elseif left then
          groups[left][key(i, j)] = true
        elseif top then
          groups[top][key(i, j)] = true
        else
          groups[#groups + 1] = { [key(i, j)] = true }
        end
      end
    end
  end

  return table.count(groups)
end

M:run()

return M
