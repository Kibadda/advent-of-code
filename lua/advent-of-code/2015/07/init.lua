local AOC = require "advent-of-code.AOC"
AOC.reload()

local M = AOC.create("2015", "07")

-- d: 72
-- e: 507
-- f: 492
-- g: 114
-- h: 65412
-- i: 65079
-- x: 123
-- y: 456
local max = 65535

function M:parse_input(file)
  for line in file:lines() do
    local split = line:split()
    if #split == 3 then
      self.input[split[3]] = tonumber(split[1]) or {
        operation = "EQ",
        one = split[1],
      }
    elseif #split == 4 then
      self.input[split[4]] = {
        operation = "NOT",
        one = tonumber(split[2]) or split[2],
      }
    elseif #split == 5 then
      self.input[split[5]] = {
        operation = split[2],
        one = tonumber(split[1]) or split[1],
        two = tonumber(split[3]) or split[3],
      }
    end
  end
end

local function eval_wires(wires, wire_name)
  local wire = wires[wire_name]
  if type(wire) == "table" then
    if wire.operation == "EQ" then
      wires[wire_name] = eval_wires(wires, wire.one)
    elseif wire.operation == "NOT" then
      wires[wire_name] = max - (type(wire.one) == "string" and eval_wires(wires, wire.one) or wire.one)
    elseif wire.operation == "AND" then
      local one = type(wire.one) == "string" and eval_wires(wires, wire.one) or wire.one
      local two = type(wire.two) == "string" and eval_wires(wires, wire.two) or wire.two
      wires[wire_name] = bit.band(one, two)
    elseif wire.operation == "OR" then
      local one = type(wire.one) == "string" and eval_wires(wires, wire.one) or wire.one
      local two = type(wire.two) == "string" and eval_wires(wires, wire.two) or wire.two
      wires[wire_name] = bit.bor(one, two)
    elseif wire.operation == "LSHIFT" then
      local one = type(wire.one) == "string" and eval_wires(wires, wire.one) or wire.one
      local two = type(wire.two) == "string" and eval_wires(wires, wire.two) or wire.two
      wires[wire_name] = bit.lshift(one, two)
    elseif wire.operation == "RSHIFT" then
      local one = type(wire.one) == "string" and eval_wires(wires, wire.one) or wire.one
      local two = type(wire.two) == "string" and eval_wires(wires, wire.two) or wire.two
      wires[wire_name] = bit.rshift(one, two)
    end
  end

  return wires[wire_name]
end

function M:solve1()
  local wires = table.deepcopy(self.input)
  self.solution:add("1", eval_wires(wires, "a"))
end

function M:solve2()
  local wires = table.deepcopy(self.input)
  wires.b = 956

  self.solution:add("2", eval_wires(wires, "a"))
end

M:run()

return M
