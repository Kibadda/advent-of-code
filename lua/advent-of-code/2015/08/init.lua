--- @class AOCDay201508: AOCDay
--- @field input string[]
local M = require("advent-of-code.AOCDay"):new("2015", "08")

function M:solve1()
  local total_chars_in_string = 0
  local total_chars_in_memory = 0

  for _, line in ipairs(self.input) do
    local skip = 0
    local list = line:to_list()
    for i = 1, #list do
      if skip > 0 then
        skip = skip - 1
      else
        if list[i] == [[\]] then
          total_chars_in_memory = total_chars_in_memory + 1
          if list[i + 1] == '"' or list[i + 1] == [[\]] then
            skip = 1
          else
            skip = 3
          end
        elseif list[i] ~= '"' then
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

  for _, line in ipairs(self.input) do
    local skip = 0
    local list = line:to_list()
    local extra = 0
    for i = 1, #list do
      if skip > 0 then
        skip = skip - 1
      else
        if list[i] == [[\]] then
          extra = extra + 1
          if list[i + 1] == '"' or list[i + 1] == [[\]] then
            extra = extra + 1
            skip = 1
          else
            skip = 3
          end
        elseif list[i] == '"' then
          extra = extra + 1
        end
      end
    end
    diff = diff + 2 + extra
  end

  return diff
end

M:run()
