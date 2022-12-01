local module = ("advent-of-code.%s.%s"):format(os.date "%Y", os.date "%d")
package.loaded[module] = nil
local ok = pcall(require, module)

if not ok then
  vim.fn.system "make"
end

---@type AOCDay
local day = require(module)

vim.pretty_print(day:solve(true))
