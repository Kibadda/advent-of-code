local ffi = require "ffi"
if not pcall(ffi.typeof, "struct timeval") then
  ffi.cdef [[
    typedef struct timeval {
      long tv_sec;
      long tv_usec;
    } timeval;

    int gettimeofday(struct timeval* t, void* tzp);
  ]]
end

---@class Timing
---@field parsing string
---@field solution_one string
---@field solution_two string
---@field all string
---@field new (fun(self: Timing, start: number, parsing: number, one: number, two: number): Timing)
local Timing = {
  parsing = "",
  solution_one = "",
  solution_two = "",
  all = "",
  new = function(self, start, parsing, one, two)
    local function format_string(diff)
      return ("%.3fs"):format(diff / 1000000)
    end
    return setmetatable({
      all = format_string(two - start),
      parsing = format_string(parsing - start),
      solution_one = format_string(one - parsing),
      solution_two = format_string(two - one),
    }, {
      __index = self,
    })
  end,
  time = function()
    local gettimeofday_struct = ffi.new "struct timeval"
    ffi.C.gettimeofday(gettimeofday_struct, nil)
    return tonumber(gettimeofday_struct.tv_sec) * 1000000 + tonumber(gettimeofday_struct.tv_usec)
  end,
}

return Timing
