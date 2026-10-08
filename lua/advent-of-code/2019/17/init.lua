--- @class AOCDay201917: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2019", "17")

require "advent-of-code.2019.intcoder"

function M:solve1()
  local output = { {} }

  for _, ascii in ipairs(Intcoder(self.input[1]):run().output) do
    if ascii == 10 then
      table.insert(output, {})
    else
      table.insert(output[#output], string.char(ascii))
    end
  end

  local alignment = 0

  for i, line in ipairs(output) do
    for j, c in ipairs(line) do
      if
        c == "#"
        and output[i - 1]
        and output[i - 1][j] == "#"
        and output[i][j - 1] == "#"
        and output[i][j + 1] == "#"
        and output[i + 1]
        and output[i + 1][j] == "#"
      then
        alignment = alignment + (i - 1) * (j - 1)
      end
    end
  end

  return alignment
end

function M:solve2()
  local map = { {} }

  return table.remove(Intcoder(self.input[1])
    :on_input(function()
      local robot
      local dir
      for i, row in ipairs(map) do
        if not robot then
          for j, c in ipairs(row) do
            if c ~= "#" and c ~= "." then
              robot = V(i, j)
              dir = match(c) {
                ["^"] = V(-1, 0),
                ["v"] = V(1, 0),
                ["<"] = V(0, -1),
                [">"] = V(0, 1),
              }
              break
            end
          end
        end
      end

      local path_list = {}

      while true do
        local forward = robot + dir
        local left = robot + dir * "L"
        local right = robot + dir * "R"

        if map[forward.x] and map[forward.x][forward.y] == "#" then
          path_list[#path_list] = path_list[#path_list] + 1
          robot = forward
        elseif map[left.x] and map[left.x][left.y] == "#" then
          path_list[#path_list + 1] = "L"
          path_list[#path_list + 1] = 0
          dir = dir * "L"
        elseif map[right.x] and map[right.x][right.y] == "#" then
          path_list[#path_list + 1] = "R"
          path_list[#path_list + 1] = 0
          dir = dir * "R"
        else
          break
        end
      end

      local path = table.concat(path_list, ",") .. ","
      local Main, A, B, C

      for a_i = 1, 20 do
        for b_i = 1, 20 do
          local a = path:sub(1, a_i)
          local b = path:sub(-b_i)
          local rem = path:gsub(a, ""):gsub(b, "")
          for c_i = 1, 20 do
            local c = rem:sub(1, c_i)
            if rem:gsub(c, "") == "" then
              A = a:sub(1, -2)
              B = b:sub(1, -2)
              C = c:sub(1, -2)
            end
          end
        end
      end

      Main = path:gsub(A, "A"):gsub(B, "B"):gsub(C, "C"):sub(1, -2)

      return {
        Main,
        A,
        B,
        C,
        "n",
      }
    end)
    :on_output(function(output)
      if output <= 127 then
        if output == 10 then
          table.insert(map, {})
        else
          table.insert(map[#map], string.char(output))
        end
      end
    end)
    :run({
      ascii = true,
      -- print = true,
      program = {
        [1] = 2,
      },
    }).output)
end

M:run()
