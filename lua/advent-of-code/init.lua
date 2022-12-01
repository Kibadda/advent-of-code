local package = ("advent-of-code.%s.%s"):format(os.date "%Y", os.date "%d")
local ok = pcall(require, package)

if not ok then
  return
end

---@type AOCDay
local day = require(package)

vim.pretty_print(day:solve(true))
