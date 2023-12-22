local AOC = require "advent-of-code.AOC"
AOC.reload()

---@class AOCDay202314: AOCDay
---@field input string[][]
local M = AOC.create("2023", "14")

---@param file file*
function M:parse(file)
  for line in file:lines() do
    table.insert(self.input, line:to_list())
  end
end

function M:solve1()
  local dish = table.deepcopy(self.input)

  for j = 1, #dish[1] do
    for i = 1, #dish do
      if dish[i][j] == "O" then
        local steps = 1
        while dish[i - steps] and dish[i - steps][j] == "." do
          dish[i - steps][j] = "O"
          dish[i - (steps - 1)][j] = "."
          steps = steps + 1
        end
      end
    end
  end

  return table.reduce(dish, 0, function(load, row, i)
    return table.reduce(row, load, function(row_load, cell)
      if cell == "O" then
        return row_load + #dish - i + 1
      end

      return row_load
    end)
  end)
end

function M:solve2()
  local dish = table.deepcopy(self.input)

  local mem = {}
  local index = 1
  local length
  while index <= 1000000000 do
    -- north
    for j = 1, #dish[1] do
      for i = 1, #dish do
        if dish[i][j] == "O" then
          local steps = 1
          while dish[i - steps] and dish[i - steps][j] == "." do
            dish[i - steps][j] = "O"
            dish[i - (steps - 1)][j] = "."
            steps = steps + 1
          end
        end
      end
    end

    -- west
    for i = 1, #dish do
      for j = 1, #dish[1] do
        if dish[i][j] == "O" then
          local steps = 1
          while dish[i][j - steps] and dish[i][j - steps] == "." do
            dish[i][j - steps] = "O"
            dish[i][j - (steps - 1)] = "."
            steps = steps + 1
          end
        end
      end
    end

    -- south
    for j = 1, #dish[1] do
      for i = #dish, 1, -1 do
        if dish[i][j] == "O" then
          local steps = 1
          while dish[i + steps] and dish[i + steps][j] == "." do
            dish[i + steps][j] = "O"
            dish[i + (steps - 1)][j] = "."
            steps = steps + 1
          end
        end
      end
    end

    -- east
    for i = 1, #dish do
      for j = #dish[1], 1, -1 do
        if dish[i][j] == "O" then
          local steps = 1
          while dish[i][j + steps] and dish[i][j + steps] == "." do
            dish[i][j + steps] = "O"
            dish[i][j + (steps - 1)] = "."
            steps = steps + 1
          end
        end
      end
    end

    local key = table.reduce(dish, "", function(s, row)
      return s .. table.concat(row)
    end)

    if mem[key] then
      length = index - mem[key]

      while index + length < 1000000000 do
        index = index + length
      end
    else
      mem[key] = index
    end

    index = index + 1
  end

  return table.reduce(dish, 0, function(load, row, i)
    return table.reduce(row, load, function(row_load, cell)
      if cell == "O" then
        return row_load + #dish - i + 1
      end

      return row_load
    end)
  end)
end

M:run()

return M
