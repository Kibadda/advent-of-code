---@deprecated
local function main(use_default_input, day, year)
  use_default_input = use_default_input == nil and true or use_default_input
  day = day or os.date "%d"
  year = year or os.date "%Y"

  local solution = "advent-of-code.Solution"
  package.loaded[solution] = nil
  require(solution)

  local aoc = "advent-of-code.AOCDay"
  package.loaded[aoc] = nil
  require(aoc)

  local helpers = "advent-of-code.helpers"
  package.loaded[helpers] = nil
  require(helpers)

  local module = ("advent-of-code.%s.%s"):format(year, day)
  package.loaded[module] = nil
  local ok = pcall(require, module)

  if not ok then
    os.execute(("./new_day -D %s:%s"):format(year, day))
  end

  ---@type AOCDay
  local aocday = require(module)

  aocday:solve(use_default_input):print()
end

main(true)
