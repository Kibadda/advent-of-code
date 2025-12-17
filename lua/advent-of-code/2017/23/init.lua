--- @class AOCDay201723: AOCDay
--- @field input { cmd: string, x: number|string, y: number|string }[]
local M = require("advent-of-code.AOCDay"):new("2017", "23")

local function assembler(a)
  -- this loops in steps of 17 from b to c and counts the non primes
  -- I converted my input into a lua program
  -- for part 2 I added an extra jump if there is one combination of [d * e = b]
  -- there is no need to find all the combinations
  local regs = { a = a, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0 }
  local mul_counter = 0

  regs.b = 99
  regs.c = regs.b
  if regs.a == 1 then
    regs.b = regs.b * 100 + 100000
    regs.c = regs.b + 17000
  end

  repeat
    regs.f = 1
    regs.d = 2
    repeat
      regs.e = 2
      repeat
        regs.g = regs.d * regs.e - regs.b
        mul_counter = mul_counter + 1
        if regs.g == 0 then
          regs.f = 0
          if regs.a == 1 then
            goto continue
          end
        end
        regs.e = regs.e + 1
        regs.g = regs.e - regs.b
      until regs.g == 0
      regs.d = regs.d + 1
      regs.g = regs.d - regs.b
    until regs.g == 0
    ::continue::
    if regs.f == 0 then
      regs.h = regs.h + 1
    end
    regs.g = regs.b - regs.c
    regs.b = regs.b + 17
  until regs.g == 0

  return a == 0 and mul_counter or regs.h
end

function M:solve1()
  return assembler(0)
end

function M:solve2()
  return assembler(1)
end

M:run()
