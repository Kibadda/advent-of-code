local AOC = require "advent-of-code.AOC"
AOC.reload()

local AOCDay = require "advent-of-code.AOCDay"

local M = AOCDay:new("2022", "13")

function M:parse_input(file)
  local function to_table(str)
    local t = {}
    if str:sub(1, 1) ~= "[" then
      return t
    elseif str:sub(#str, #str) ~= "]" then
      return t
    else
      local content = str:sub(2, #str - 1)
      local split = content:split ","
      local combined = {}
      local count_braces = 0
      for _, c in ipairs(split) do
        if tonumber(c) ~= nil then
          if count_braces > 0 then
            table.insert(combined, c)
            local _, opening = c:gsub("%[", "#")
            local _, closing = c:gsub("%]", "#")
            count_braces = count_braces + opening - closing
          else
            if #combined > 0 then
              table.insert(t, to_table(table.concat(combined, ",")))
              combined = {}
            end
            table.insert(t, tonumber(c))
          end
        else
          if #combined > 0 and count_braces == 0 then
            table.insert(t, to_table(table.concat(combined, ",")))
            combined = {}
          end
          table.insert(combined, c)
          local _, opening = c:gsub("%[", "#")
          local _, closing = c:gsub("%]", "#")
          count_braces = count_braces + opening - closing
        end
      end
      if #combined > 0 then
        table.insert(t, to_table(table.concat(combined, ",")))
      end
    end

    return t
  end

  local pair = {
    first = nil,
    second = nil,
  }
  for line in file:lines() do
    if line == "" then
      table.insert(self.input, pair)
      pair = {
        first = nil,
        second = nil,
      }
    else
      if not pair.first then
        pair.first = to_table(line)
      else
        pair.second = to_table(line)
      end
    end
  end
end

local function check_tables(first, second)
  for i = 1, math.min(#first, #second) do
    if type(first[i]) == "number" and type(second[i]) == "number" then
      if first[i] > second[i] then
        return false
      elseif first[i] < second[i] then
        return true
      end
    else
      local check = check_tables(
        type(first[i]) == "table" and first[i] or { first[i] },
        type(second[i]) == "table" and second[i] or { second[i] }
      )
      if type(check) == "boolean" then
        return check
      end
    end
  end

  if #first ~= #second then
    return #second - #first > 0
  end

  return "weiter suchen"
end

function M:solve1()
  local solution = 0

  for i, pair in ipairs(self.input) do
    if check_tables(pair.first, pair.second) then
      solution = solution + i
    end
  end

  self.solution:add("1", solution)
end

function M:solve2()
  local all_packets = {}
  for _, pair in ipairs(self.input) do
    table.insert(all_packets, pair.first)
    table.insert(all_packets, pair.second)
  end

  table.insert(all_packets, { { 2 } })
  table.insert(all_packets, { { 6 } })

  table.sort(all_packets, check_tables)

  local divider_one, divider_two
  for i, packet in ipairs(all_packets) do
    if #packet == 1 and type(packet[1]) == "table" and #packet[1] == 1 and packet[1][1] == 2 then
      divider_one = i
    end
    if #packet == 1 and type(packet[1]) == "table" and #packet[1] == 1 and packet[1][1] == 6 then
      divider_two = i
    end
    if divider_two ~= nil and divider_one ~= nil then
      break
    end
  end

  self.solution:add("2", divider_one * divider_two)
end

M:run(false)

return M
