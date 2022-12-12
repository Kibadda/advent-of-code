local AOCDay = require "advent-of-code.AOCDay"

local M = AOCDay:new("2015", "08")

function M:solve1()
  local total_chars_in_string = 0
  local total_chars_in_memory = 0

  for _, line in ipairs(self.lines) do
    local skip = 0
    line = line:to_list()
    for i = 1, #line do
      if skip > 0 then
        skip = skip - 1
      else
        if line[i] == [[\]] then
          total_chars_in_memory = total_chars_in_memory + 1
          if line[i + 1] == '"' or line[i + 1] == [[\]] then
            skip = 1
          else
            skip = 3
          end
        elseif line[i] == '"' then
        else
          total_chars_in_memory = total_chars_in_memory + 1
        end
      end
    end

    total_chars_in_string = total_chars_in_string + #line
  end

  return total_chars_in_string - total_chars_in_memory
end

function M:solve2()
  local diff = 0

  for _, line in ipairs(self.lines) do
    local skip = 0
    line = line:to_list()
    local extra = 0
    for i = 1, #line do
      if skip > 0 then
        skip = skip - 1
      else
        if line[i] == [[\]] then
          extra = extra + 1
          if line[i + 1] == '"' or line[i + 1] == [[\]] then
            extra = extra + 1
            skip = 1
          else
            skip = 3
          end
        elseif line[i] == '"' then
          extra = extra + 1
        else
        end
      end
    end
    diff = diff + 2 + extra
  end

  return diff
end

return M
