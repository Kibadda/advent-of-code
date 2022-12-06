local function main(use_default_input, year, day)
  use_default_input = use_default_input == nil and true or use_default_input
  year = year or os.date "%Y"
  day = day or os.date "%d"

  local module = ("advent-of-code.%s.%s"):format(year, day)
  package.loaded[module] = nil
  local ok = pcall(require, module)

  if not ok then
    os.execute(("./new_day -D %s:%s"):format(year, day))
  end

  ---@type AOCDay
  local aocday = require(module)

  local solution = aocday:solve(use_default_input)
  print("solution one: " .. solution.one)
  print("solution two: " .. solution.two)
end

main()
