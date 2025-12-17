--- @class AOCDay202205: AOCDay
--- @field input { stacks: table, procedures: { move: number, from: number, to: number }[] }
local M = require("advent-of-code.AOCDay"):new("2022", "05")

--- @param lines string[]
function M:parse(lines)
  local crates = {}
  local procedures = {}

  local fill_crates = true

  for _, line in ipairs(lines) do
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

  self.input = {
    stacks = stacks,
    procedures = procedures,
  }
end

function M:solver(fun)
  local stacks = table.deepcopy(self.input.stacks)

  for _, procedure in ipairs(self.input.procedures) do
    fun(procedure, stacks)
  end

  local top_crates = ""
  for _, stack in ipairs(stacks) do
    top_crates = top_crates .. stack[#stack]
  end

  return top_crates
end

function M:solve1()
  return self:solver(function(procedure, stacks)
    for _ = 1, procedure.move do
      table.insert(stacks[procedure.to], table.remove(stacks[procedure.from]))
    end
  end)
end

function M:solve2()
  return self:solver(function(procedure, stacks)
    local pos = #stacks[procedure.from] - procedure.move + 1
    for _ = 1, procedure.move do
      table.insert(stacks[procedure.to], table.remove(stacks[procedure.from], pos))
    end
  end)
end

M:run()
