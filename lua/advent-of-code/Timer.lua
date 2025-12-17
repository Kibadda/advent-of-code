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

local function format(diff)
  return ("%.4fs"):format(diff / 1000000)
end

local function time()
  local gettimeofday_struct = ffi.new "struct timeval"
  ffi.C.gettimeofday(gettimeofday_struct, nil)
  return tonumber(gettimeofday_struct.tv_sec) * 1000000 + tonumber(gettimeofday_struct.tv_usec)
end

--- @class Timer
--- @field timings table<string, number>
--- @field start fun(self: Timer)
--- @field parse fun(self: Timer)
--- @field one fun(self: Timer)
--- @field two fun(self: Timer)
--- @field format fun(self: Timer): table
--- @field new (fun(self: Timer): Timer)
local Timer = {
  timings = {
    start = 0,
    parse = 0,
    one = 0,
    two = 0,
  },
  new = function(self)
    return setmetatable({
      timings = {
        start = 0,
        parse = 0,
        one = 0,
        two = 0,
      },
    }, {
      __index = self,
    })
  end,
  start = function(self)
    self.timings.start = time()
  end,
  parse = function(self)
    self.timings.parse = time()
  end,
  one = function(self)
    self.timings.one = time()
  end,
  two = function(self)
    self.timings.two = time()
  end,
  format = function(self)
    return {
      parse = format(self.timings.parse - self.timings.start),
      one = format(self.timings.one - self.timings.parse),
      two = format(self.timings.two - self.timings.one),
      all = format(self.timings.two - self.timings.start),
    }
  end,
}

return Timer
