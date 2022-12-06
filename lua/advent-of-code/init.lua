local module = ("advent-of-code.%s.%s"):format(os.date "%Y", os.date "%d")
package.loaded[module] = nil
local ok = pcall(require, module)

if not ok then
  os.execute "make"
end

---@type AOCDay
local day = require(module)

local solution = day:solve(true)
print("solution one: " .. solution.one)
print("solution two: " .. solution.two)
