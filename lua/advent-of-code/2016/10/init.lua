local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2016", "10")

function M:parse_input(file)
  self.input = {
    bots = {},
    instructions = {},
  }

  for line in file:lines() do
    local split = line:split()
    if split[1] == "value" then
      local name = "bot" .. split[6]
      self.input.bots[name] = self.input.bots[name] or {}
      table.insert(self.input.bots[name], tonumber(split[2]))
    else
      local instruction = {}
      if split[6] == "output" then
        instruction.lowOutput = split[7]
      else
        instruction.low = split[7]
      end
      if split[11] == "output" then
        instruction.highOutput = split[12]
      else
        instruction.high = split[12]
      end
      self.input.instructions["bot" .. split[2]] = instruction
    end
  end
end

function M:solver(compareValues)
  local input = table.deepcopy(self.input)
  local outputs = {}

  local botNumber
  while true do
    local modified = false
    for bot, values in pairs(input.bots) do
      if #values == 2 then
        local a, b = unpack(values)
        if (a == compareValues[1] and b == compareValues[2]) or (a == compareValues[2] and b == compareValues[1]) then
          botNumber = bot
          break
        end
        local instruction = input.instructions[bot]
        if instruction.lowOutput then
          outputs[instruction.lowOutput] = outputs[instruction.lowOutput] or {}
          outputs[instruction.lowOutput] = a <= b and a or b
        else
          local name = "bot" .. instruction.low
          input.bots[name] = input.bots[name] or {}
          table.insert(input.bots[name], a <= b and a or b)
        end
        if instruction.highOutput then
          outputs[instruction.highOutput] = outputs[instruction.highOutput] or {}
          outputs[instruction.highOutput] = a > b and a or b
        else
          local name = "bot" .. instruction.high
          input.bots[name] = input.bots[name] or {}
          table.insert(input.bots[name], a > b and a or b)
        end
        input.bots[bot] = {}
        modified = true
      end
    end

    if not modified or botNumber then
      break
    end
  end

  return {
    botNumber,
    outputs,
  }
end

function M:solve1(compareValues)
  self.solution:add("1", self:solver(compareValues)[1])
end

function M:solve2(compareValues)
  local outputs = self:solver(compareValues)[2]
  self.solution:add("2", outputs["0"] * outputs["1"] * outputs["2"])
end

M:run(false, { { 5, 2 }, { 61, 17 } }, { { math.huge, math.huge } })

return M
