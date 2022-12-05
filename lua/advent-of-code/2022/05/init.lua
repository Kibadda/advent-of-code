local AOCDay = require "advent-of-code.AOCDay"

local M = AOCDay:new("2022", "05")

function M:parse_input()
  local crates = {}
  local procedures = {}

  local fill_crates = true

  for _, line in ipairs(self.lines) do
    if line == "" then
      fill_crates = false
    else
      if fill_crates then
        table.insert(crates, line)
      else
        local split = line:split()
        table.insert(procedures, {
          move = tonumber(split[2]),
          from = tonumber(split[4]),
          to = tonumber(split[6]),
        })
      end
    end
  end

  local stacks = {}
  for _, i in ipairs(crates[#crates]:split()) do
    local stack = {}
    for j = #crates - 1, 1, -1 do
      local pos = (i - 1) * 4 + 2
      local crate = crates[j]:sub(pos, pos)
      if crate ~= " " and crate ~= "" then
        table.insert(stack, crate)
      end
    end
    stacks[tonumber(i)] = stack
  end

  return {
    stacks = stacks,
    procedures = procedures,
  }
end

function M:solve1()
  local input = self:parse_input()
  local stacks = input.stacks

  for _, procedure in ipairs(input.procedures) do
    for _ = 1, procedure.move do
      local from = stacks[procedure.from]
      table.insert(stacks[procedure.to], from[#from])
      from[#from] = nil
    end
  end

  local top_crates = ""
  for _, stack in ipairs(stacks) do
    top_crates = top_crates .. stack[#stack]
  end

  return top_crates
end

function M:solve2()
  local input = self:parse_input()
  local stacks = input.stacks

  for _, procedure in ipairs(input.procedures) do
    local from = stacks[procedure.from]
    local pos = #from - procedure.move + 1
    for _ = 1, procedure.move do
      table.insert(stacks[procedure.to], from[pos])
      table.remove(from, pos)
    end
  end

  local top_crates = ""
  for _, stack in ipairs(stacks) do
    top_crates = top_crates .. stack[#stack]
  end

  return top_crates
end

return M
