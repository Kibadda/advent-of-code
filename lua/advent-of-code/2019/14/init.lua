--- @class AOCDay201914: AOCDay
--- @field input table<string, { quant: integer, inputs: table<string, integer> }>
local M = require("advent-of-code.AOCDay"):new("2019", "14")

--- @param lines string[]
function M:parse(lines)
  self.input = {}

  for _, line in ipairs(lines) do
    local inputs, output = unpack(line:split "=>")
    inputs = inputs:trim()
    output = output:trim()
    local output_quant, output_name = unpack(output:split())

    self.input[output_name] = {
      quant = assert(tonumber(output_quant)),
      inputs = table.reduce(inputs:split ",", {}, function(carry, input)
        local input_quant, input_name = unpack(input:trim():split())
        carry[input_name] = tonumber(input_quant)
        return carry
      end),
    }
  end
end

function M:solver(element, quant, inventory)
  inventory = inventory or {}
  local multiplier = math.ceil(quant / self.input[element].quant)
  inventory[element] = self.input[element].quant * multiplier - quant

  local total = 0
  for input_name, input_quant in pairs(self.input[element].inputs) do
    local needed = input_quant * multiplier
    if input_name == "ORE" then
      total = total + needed
    else
      if inventory[input_name] then
        if inventory[input_name] >= needed then
          inventory[input_name] = inventory[input_name] - needed
          needed = 0
        else
          needed = needed - inventory[input_name]
          inventory[input_name] = 0
        end
      end

      if needed > 0 then
        total = total + self:solver(input_name, needed, inventory)
      end
    end
  end
  return total
end

function M:solve1()
  return self:solver("FUEL", 1)
end

function M:solve2()
  local ore_per_fuel = self.solution["1"]
  local avail_ore = 1000000000000
  local min_fuel = math.floor(avail_ore / ore_per_fuel)
  local min_fuel_ore = self:solver("FUEL", min_fuel)
  ore_per_fuel = math.floor(min_fuel_ore / min_fuel)
  min_fuel = math.floor(avail_ore / ore_per_fuel)

  for i = min_fuel, math.huge do
    local ore = self:solver("FUEL", i)
    if ore > avail_ore then
      return i - 1
    end
  end
end

M:run()
